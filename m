Return-Path: <SRS0=G82f=GH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A393AC433E6
	for <kvmarm@archiver.kernel.org>; Mon,  4 Jan 2021 18:26:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D532121D94
	for <kvmarm@archiver.kernel.org>; Mon,  4 Jan 2021 18:26:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D532121D94
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D4BA4B19E;
	Mon,  4 Jan 2021 13:26:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MVJndefx3RLo; Mon,  4 Jan 2021 13:26:47 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BDDFD4B137;
	Mon,  4 Jan 2021 13:26:47 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A8CF4B0F1
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Jan 2021 13:26:46 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SkF2r0CmfyiU for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Jan 2021 13:26:45 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 47B964B0F3
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Jan 2021 13:26:45 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 1EDFD2075E;
 Mon,  4 Jan 2021 18:26:44 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kwUZ0-005HbV-06; Mon, 04 Jan 2021 18:26:42 +0000
MIME-Version: 1.0
Date: Mon, 04 Jan 2021 18:26:41 +0000
From: Marc Zyngier <maz@kernel.org>
To: Qian Cai <qcai@redhat.com>
Subject: Re: [PATCH] KVM: arm64: Don't access PMCR_EL0 when no PMU is available
In-Reply-To: <a0fcd5a4a595deddd990a6327568c82a1e94948a.camel@redhat.com>
References: <20201210083059.1277162-1-maz@kernel.org>
 <703e1b5f2db1631e8f9c55619909fe66eb069f25.camel@redhat.com>
 <579c839a0016107af66e704f147f9814@kernel.org>
 <f4300d00b9d2540bf90a6b1baadf030a2e4c92ed.camel@redhat.com>
 <bd725a533e4754b0d5634574bcab4b0d@kernel.org>
 <a0fcd5a4a595deddd990a6327568c82a1e94948a.camel@redhat.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <f7b97771ed29c7630f678a8939a591dd@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: qcai@redhat.com, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kernel-team@android.com, sfr@canb.auug.org.au,
 linux-next@vger.kernel.org, alexandru.elisei@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
 Linux Next Mailing List <linux-next@vger.kernel.org>, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 2021-01-04 18:20, Qian Cai wrote:
> On Mon, 2021-01-04 at 16:27 +0000, Marc Zyngier wrote:
>> On 2021-01-04 16:22, Qian Cai wrote:
>> > On Mon, 2021-01-04 at 16:08 +0000, Marc Zyngier wrote:
>> > > On 2021-01-04 15:47, Qian Cai wrote:
>> > > > On Thu, 2020-12-10 at 08:30 +0000, Marc Zyngier wrote:
>> > > > > We reset the guest's view of PMCR_EL0 unconditionally, based on
>> > > > > the host's view of this register. It is however legal for an
>> > > > > imnplementation not to provide any PMU, resulting in an UNDEF.
>> > > > >
>> > > > > The obvious fix is to skip the reset of this shadow register
>> > > > > when no PMU is available, sidestepping the issue entirely.
>> > > > > If no PMU is available, the guest is not able to request
>> > > > > a virtual PMU anyway, so not doing nothing is the right thing
>> > > > > to do!
>> > > > >
>> > > > > It is unlikely that this bug can hit any HW implementation
>> > > > > though, as they all provide a PMU. It has been found using nested
>> > > > > virt with the host KVM not implementing the PMU itself.
>> > > > >
>> > > > > Fixes: ab9468340d2bc ("arm64: KVM: Add access handler for PMCR
>> > > > > register")
>> > > > > Signed-off-by: Marc Zyngier <maz@kernel.org>
>> > > >
>> > > > Reverting this commit on the top of today's linux-next fixed a qemu-kvm
>> > > > coredump
>> > > > issue on TX2 while starting a guest.
>> > > >
>> > > > - host kernel .config:
>> > > > https://cailca.coding.net/public/linux/mm/git/files/master/arm64.config
>> > > >
>> > > > # /usr/libexec/qemu-kvm -name ubuntu-20.04-server-cloudimg -cpu host
>> > > > -smp 2 -m 2g
>> > > > -drive
>> > > > if=none,format=qcow2,file=./ubuntu-20.04-server-cloudimg.qcow2,id=hd
>> > > > -device virtio-scsi -device scsi-hd,drive=hd -cdrom
>> > > > ./ubuntu-20.04-server-cloudimg.iso
>> > > > -bios /usr/share/AAVMF/AAVMF_CODE.fd -M gic-version=host -nographic
>> > > > -nic user,model=virtio,hostfwd=tcp::2222-:22
>> > > >
>> > > > qemu-kvm: /builddir/build/BUILD/qemu-4.2.0/target/arm/helper.c:1812:
>> > > > pmevcntr_rawwrite: Assertion `counter < pmu_num_counters(env)' failed.
>> > >
>> > > You don't have KVM_ARM_PMU selected in your config, so QEMU cannot
>> > > access the PMU registers, and no counters are exposed.
>> >
>> > Well, isn't it the rule that don't break the userspace? qemu works fine
>> > with
>> > KVM_ARM_PMU=n until this commit.
>> 
>> No, it doesn't "work fine". It gets random data that potentially makes
>> no sense,
>> depending on the HW this runs on.
>> 
>> Now, userspace tells you that your kernel is misconfigured. I see it 
>> as
>> an improvement.
> 
> Marc, do you suggest that CONFIG_KVM=y should select KVM_ARM_PMU=y 
> then?
> Otherwise, this is rather difficult for users to figure out and a core 
> dump with
> an implicit error message from qemu is not that helpful.

What I'm suggesting is this [1], which is to get rid of KVM_ARM_PMU
completely. At least, the kernel configuration will be consistent.

Overall, I think there is an issue with KVM exposing more than it
should to userspace when no PMU is defined, but I don't think that's
the problem you are seeing.

         M.

[1] https://lore.kernel.org/r/20210104172723.2014324-1-maz@kernel.org
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
