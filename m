Return-Path: <SRS0=evlJ=6L=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91962C55199
	for <kvmarm@archiver.kernel.org>; Mon, 27 Apr 2020 17:33:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 17F74206D9
	for <kvmarm@archiver.kernel.org>; Mon, 27 Apr 2020 17:33:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="FXKAonvd"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 17F74206D9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AF1244B198;
	Mon, 27 Apr 2020 13:33:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gtCNKOSLWtiQ; Mon, 27 Apr 2020 13:33:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9EE3F4B199;
	Mon, 27 Apr 2020 13:33:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 249664B18A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Apr 2020 13:33:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jD91YklMObLZ for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Apr 2020 13:33:39 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 010FF4B127
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Apr 2020 13:33:38 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id D451F206D9;
 Mon, 27 Apr 2020 17:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1588008818;
 bh=En6PMPermi7/qXogYL4qV4kDVxomi2kZ/siwiOXKS1E=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=FXKAonvdo0qpOkOILva/raUkYBFNRi5fSKy/mA3pCRpZsxvhAUHtwTAdO9X7dKEeC
 2beGGpYruB3VdYBKTmLGYPRNuVre4U5QNYbQZudz9wksSesyOHzLUUTfJNT75eG6Y3
 W5Vf41J+8GMrpCbbsq0HApS7YkJ7ibl9yGoFhHLk=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jT7dQ-006ng9-79; Mon, 27 Apr 2020 18:33:36 +0100
Date: Mon, 27 Apr 2020 18:33:31 +0100
From: Marc Zyngier <maz@kernel.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH][kvmtool] kvm: Request VM specific limits instead of
 system-wide ones
Message-ID: <20200427183331.48f411f5@why>
In-Reply-To: <7ac17890-72d1-1c81-e513-5d4f7841ca9d@arm.com>
References: <20200427141738.285217-1-maz@kernel.org>
 <d27e4a14-34b8-7f3d-1e58-ef2ae13e443b@arm.com>
 <7ac17890-72d1-1c81-e513-5d4f7841ca9d@arm.com>
Organization: Approximate
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: alexandru.elisei@arm.com, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com,
 suzuki.poulose@arm.com, will@kernel.org, Andre.Przywara@arm.com,
 ardb@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, Andre Przywara <Andre.Przywara@arm.com>,
 Ard Biesheuvel <ardb@kernel.org>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Mon, 27 Apr 2020 16:00:58 +0100
Alexandru Elisei <alexandru.elisei@arm.com> wrote:

> Hi,
> 
> On 4/27/20 3:44 PM, Alexandru Elisei wrote:
> > Hi,
> >
> > On 4/27/20 3:17 PM, Marc Zyngier wrote:  
> >> On arm64, the maximum number of vcpus is constrained by the type
> >> of interrupt controller that has been selected (GICv2 imposes a
> >> limit of 8 vcpus, while GICv3 currently has a limit of 512).
> >>
> >> It is thus important to request this limit on the VM file descriptor
> >> rather than on the one that corresponds to /dev/kvm, as the latter
> >> is likely to return something that doesn't take the constraints into
> >> account.
> >>
> >> Reported-by: Ard Biesheuvel <ardb@kernel.org>
> >> Signed-off-by: Marc Zyngier <maz@kernel.org>
> >> ---
> >>  kvm.c | 4 ++--
> >>  1 file changed, 2 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/kvm.c b/kvm.c
> >> index e327541..3d5173d 100644
> >> --- a/kvm.c
> >> +++ b/kvm.c
> >> @@ -406,7 +406,7 @@ int kvm__recommended_cpus(struct kvm *kvm)
> >>  {
> >>  	int ret;
> >>  
> >> -	ret = ioctl(kvm->sys_fd, KVM_CHECK_EXTENSION, KVM_CAP_NR_VCPUS);
> >> +	ret = ioctl(kvm->vm_fd, KVM_CHECK_EXTENSION, KVM_CAP_NR_VCPUS);
> >>  	if (ret <= 0)
> >>  		/*
> >>  		 * api.txt states that if KVM_CAP_NR_VCPUS does not exist,
> >> @@ -421,7 +421,7 @@ int kvm__max_cpus(struct kvm *kvm)
> >>  {
> >>  	int ret;
> >>  
> >> -	ret = ioctl(kvm->sys_fd, KVM_CHECK_EXTENSION, KVM_CAP_MAX_VCPUS);
> >> +	ret = ioctl(kvm->vm_fd, KVM_CHECK_EXTENSION, KVM_CAP_MAX_VCPUS);
> >>  	if (ret <= 0)
> >>  		ret = kvm__recommended_cpus(kvm);
> >>    
> > I've checked that gic__create comes before the call kvm__recommended_capus:
> > gic__create is in core_init (called via kvm__init->kvm_arch_init), and
> > kvm__recommended_cpus is in base_init (called via kvm__cpu_init ->
> > kvm__{recommended,max}_cpus).
> >
> > The KVM api documentation states that KVM_CHECK_EXTENSION is available for the vm
> > fd only if the system capability KVM_CAP_CHECK_EXTENSION_VM is present. kvmtool
> > already has a function for checking extensions on the vm fd, it's called
> > kvm__supports_vm_extension. Can we use that instead of doing the ioctl directly on
> > the vm fd?  
> 
> Scratch that, kvm__supports_vm_extension returns a bool, not an int.
> How about we write kvm__check_vm_extension that returns an int, and
> kvm__supports_vm_extension calls it?

That, or we just change the return type for kvm__supports_vm_extension,
and hack the only places that uses it so far (the GIC code) to detect
the error.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
