From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v4 06/12] KVM: arm64: implement basic ITS register handlers
Date: Wed, 25 May 2016 14:49:03 +0100
Message-ID: <0c89ea29-4c40-ce87-f499-d600c466ace4@arm.com>
References: <1458958450-19662-1-git-send-email-andre.przywara@arm.com>
 <1458958450-19662-7-git-send-email-andre.przywara@arm.com>
 <5704D8B8.4000504@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6777949B2E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 May 2016 09:44:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AmMGJ5n6YSXw for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 May 2016 09:44:53 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 69B3F412C2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 May 2016 09:44:52 -0400 (EDT)
In-Reply-To: <5704D8B8.4000504@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Eric Auger <eric.auger@linaro.org>, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Eric,

On 06/04/16 10:36, Eric Auger wrote:
> Hi Andre,
> On 03/26/2016 03:14 AM, Andre Przywara wrote:
>> Add emulation for some basic MMIO registers used in the ITS emulation.

...

>> +
>> +/*
>> + * By writing to CWRITER the guest announces new commands to be processed.
>> + * Since we cannot read from guest memory inside the ITS spinlock, we
>> + * iterate over the command buffer (with the lock dropped) until the read
>> + * pointer matches the write pointer. Other VCPUs writing this register in the
>> + * meantime will just update the write pointer, leaving the command
>> + * processing to the first instance of the function.
>> + */
>> +static int vgic_mmio_write_its_cwriter(struct kvm_vcpu *vcpu,
>> +				       struct kvm_io_device *this,
>> +				       gpa_t addr, int len, const void *val)
>> +{
>> +	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
>> +	struct vgic_its *its = &dist->its;
>> +	gpa_t cbaser = its_cmd_buffer_base(vcpu->kvm);
>> +	u64 cmd_buf[4];
>> +	u32 reg;
>> +	bool finished;
>> +
>> +	reg = mask64(its->cwriter & 0xfffe0, addr & 7, len, val);
>> +	reg &= 0xfffe0;
>> +	if (reg > its_cmd_buffer_size(vcpu->kvm))
>> +		return 0;
>> +
>> +	spin_lock(&its->lock);
>> +
>> +	/*
>> +	 * If there is still another VCPU handling commands, let this
>> +	 * one pick up the new CWRITER and process "our" new commands as well.
>> +	 */
>> +	finished = (its->cwriter != its->creadr);
> empty?

Maybe that is indeed less misleading ...

>> +	its->cwriter = reg;
>> +
>> +	spin_unlock(&its->lock);
> Assuming we have 2 vcpus attempting a cwriter write at the same moment I
> don't understand what does guarantee they are not going to execute the
> following loop concurrently and possibly execute vits_handle_command
> twice on the same cmd from the same its->creadr start?

So does my explanation of the algorithm in that other mail today explain
it? Or do you still see a hole in the locking scheme here?

>> +
>> +	while (!finished) {
>> +		int ret = kvm_read_guest(vcpu->kvm, cbaser + its->creadr,
>> +					 cmd_buf, 32);
>> +		if (ret) {
>> +			/*
>> +			 * Gah, we are screwed. Reset CWRITER to that command
>> +			 * that we have finished processing and return.
>> +			 */
>> +			spin_lock(&its->lock);
>> +			its->cwriter = its->creadr;
> don't get why do you set the queue empty?

So from a guest's point of view this is something like an ITS internal
error which shouldn't happen. So I just bail out, but leave the queue in
a consistent (read: empty) state to allow possible future commands to be
processed at best effort.
I guess this is the best we can come up with, since there is no feasible
way of communicating errors back(?)

Cheers,
Andre.
