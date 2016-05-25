From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v4 10/12] KVM: arm64: implement ITS command queue command
 handlers
Date: Wed, 25 May 2016 15:34:32 +0100
Message-ID: <904cef0a-4f9e-2510-c6bc-19c45bd2ef1e@arm.com>
References: <1458958450-19662-1-git-send-email-andre.przywara@arm.com>
 <1458958450-19662-11-git-send-email-andre.przywara@arm.com>
 <3F572EDF-329A-4D6D-BA06-7E6F3B89C819@caviumnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D4F4C49B3B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 May 2016 10:30:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qa4tMkq+o8TQ for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 May 2016 10:30:24 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 985CF499A1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 May 2016 10:30:24 -0400 (EDT)
In-Reply-To: <3F572EDF-329A-4D6D-BA06-7E6F3B89C819@caviumnetworks.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: "Chalamarla, Tirumalesh" <Tirumalesh.Chalamarla@caviumnetworks.com>, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Eric Auger <eric.auger@linaro.org>
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Tirumalesh,

....

>> +/* The MOVI command moves an ITTE to a different collection. */
>> +static int vits_cmd_handle_movi(struct kvm *kvm, u64 *its_cmd)
>> +{
>> +	struct vgic_its *its = &kvm->arch.vgic.its;
>> +	u32 device_id = its_cmd_get_deviceid(its_cmd);
>> +	u32 event_id = its_cmd_get_id(its_cmd);
>> +	u32 coll_id = its_cmd_get_collection(its_cmd);
>> +	struct its_itte *itte;
>> +	struct its_collection *collection;
>> +	int ret;
>> +
>> +	spin_lock(&its->lock);
>> +	itte = find_itte(kvm, device_id, event_id);
>> +	if (!itte) {
>> +		ret = E_ITS_MOVI_UNMAPPED_INTERRUPT;
>> +		goto out_unlock;
>> +	}
>> +	if (!its_is_collection_mapped(itte->collection)) {
>> +		ret = E_ITS_MOVI_UNMAPPED_COLLECTION;
>> +		goto out_unlock;
>> +	}
>> +
>> +	collection = find_collection(kvm, coll_id);
>> +	if (!its_is_collection_mapped(collection)) {
>> +		ret = E_ITS_MOVI_UNMAPPED_COLLECTION;
>> +		goto out_unlock;
>> +	}
>> +
>> +	itte->collection = collection;
>> +	update_affinity(kvm, collection);
>> +
> 
> Not planning to send this down to Physical ITS in case of VFIO for performance reasons?

Why should we?
So in general: this virtual ITS is a purely emulated one, it does not
depend on any hardware ITS to work. Also at this point we don't focus on
VFIO (in fact this doesn't even work without further patches).
So it would break abstraction to pass on commands. Besides I don't see
the benefit of passing a 32-byte structure around, which needs to be
validated (and thus touched) anyway.
Also in this particular case: Why would a change of the _virtual_
affinity affect a VFIO IRQ on the host at all?
Actually the collection IDs of the guests are _totally_ separate and
unrelated to a host collection ID.

Cheers,
Andre
