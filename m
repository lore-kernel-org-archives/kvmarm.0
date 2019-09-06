Return-Path: <SRS0=tFZo=XB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_ADSP_ALL,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E742C43140
	for <kvmarm@archiver.kernel.org>; Fri,  6 Sep 2019 13:02:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1DCE520578
	for <kvmarm@archiver.kernel.org>; Fri,  6 Sep 2019 13:02:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="GfpINObq"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1DCE520578
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 95EC34A584;
	Fri,  6 Sep 2019 09:02:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@amazon.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Lg83yt01Bupe; Fri,  6 Sep 2019 09:02:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 912D44A58B;
	Fri,  6 Sep 2019 09:02:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 40F434A562
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Sep 2019 09:02:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YEPfpyqNfsM7 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 Sep 2019 09:02:15 -0400 (EDT)
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3B03D4A55F
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Sep 2019 09:02:15 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
 t=1567774935; x=1599310935;
 h=subject:to:cc:references:from:message-id:date:
 mime-version:in-reply-to:content-transfer-encoding;
 bh=BsL/MpON9lOcR0hZ9plTd/PmmADOU1tKuQ65tHkbvfo=;
 b=GfpINObqBPMUrX3J+wt23j0+alS1eQA27hYxqlZIj4eZFuKwZ7hgEfBt
 9B+b3emR+MA/Js9lRj4EyEay7o48JE82/aqMxaJwkUjcRnyrIBRTsd5eX
 HEz3NZ38b0+Sp0roJE5y815QmTeFrzmEHDkLWwfesU+bWosFXsoAFOQ+J Y=;
X-IronPort-AV: E=Sophos;i="5.64,473,1559520000"; d="scan'208";a="413929647"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO
 email-inbound-relay-2b-4ff6265a.us-west-2.amazon.com) ([10.124.125.6])
 by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP;
 06 Sep 2019 13:02:12 +0000
Received: from EX13MTAUWC001.ant.amazon.com
 (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
 by email-inbound-relay-2b-4ff6265a.us-west-2.amazon.com (Postfix) with ESMTPS
 id 56569A23DF; Fri,  6 Sep 2019 13:02:12 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 6 Sep 2019 13:02:11 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.160.20) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 6 Sep 2019 13:02:09 +0000
Subject: Re: [UNVERIFIED SENDER] Re: [PATCH 1/1] KVM: inject data abort if
 instruction cannot be decoded
To: Marc Zyngier <maz@kernel.org>, Christoffer Dall <christoffer.dall@arm.com>
References: <20190904180736.29009-1-xypron.glpk@gmx.de>
 <86r24vrwyh.wl-maz@kernel.org>
 <CAFEAcA-mc6cLmRGdGNOBR0PC1f_VBjvTdAL6xYtKjApx3NoPgQ@mail.gmail.com>
 <86mufjrup7.wl-maz@kernel.org>
 <CAFEAcA9qkqkOTqSVrhTpt-NkZSNXomSBNiWo_D6Kr=QKYRRf=w@mail.gmail.com>
 <20190905092223.GC4320@e113682-lin.lund.arm.com>
 <4b6662bd-56e4-3c10-3b65-7c90828a22f9@kernel.org>
 <20190906080033.GF4320@e113682-lin.lund.arm.com>
 <a58c5f76-641a-8381-2cf3-e52d139c4236@amazon.com>
 <0a99ce2b-7700-2a2f-eb3a-4922631cbe02@kernel.org>
From: Alexander Graf <graf@amazon.com>
Message-ID: <9745a09c-3410-38a5-1399-24eefbed8336@amazon.com>
Date: Fri, 6 Sep 2019 15:02:07 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <0a99ce2b-7700-2a2f-eb3a-4922631cbe02@kernel.org>
Content-Language: en-US
X-Originating-IP: [10.43.160.20]
X-ClientProxiedBy: EX13D07UWB002.ant.amazon.com (10.43.161.131) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Precedence: Bulk
Cc: =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>, Heinrich
 Schuchardt <xypron.glpk@gmx.de>,
 lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Stefan Hajnoczi <stefanha@redhat.com>, kvmarm@lists.cs.columbia.edu,
 arm-mail-list <linux-arm-kernel@lists.infradead.org>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
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



On 06.09.19 14:34, Marc Zyngier wrote:
> On 06/09/2019 13:08, Alexander Graf wrote:
>>
>>
>> On 06.09.19 10:00, Christoffer Dall wrote:
>>> On Thu, Sep 05, 2019 at 02:09:18PM +0100, Marc Zyngier wrote:
> 
> [...]
> 
>>>>> @@ -673,6 +694,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
>>>>>    		ret = kvm_handle_mmio_return(vcpu, vcpu->run);
>>>>>    		if (ret)
>>>>>    			return ret;
>>>>> +	} else if (run->exit_reason == KVM_EXIT_ARM_NISV) {
>>>>> +		kvm_inject_undefined(vcpu);
>>>>
>>>> Just to make sure I understand: Is the expectation here that userspace
>>>> could clear the exit reason if it managed to handle the exit? And
>>>> otherwise we'd inject an UNDEF on reentry?
>>>>
>>>
>>> Yes, but I think we should change that to an external abort.  I'll test
>>> something and send a proper patch with more clear documentation.
>>
>> Why not leave the injection to user space in any case? API wise there is
>> no need to be backwards compatible, as we require the CAP to be enabled,
>> right?
>>
>> IMHO it should be 100% a policy decision in user space whether to
>> emulate and what type of exception to inject, if anything.
> 
> The exception has to be something that the trapped instruction can
> actually generate. An UNDEF is definitely wrong, as the guest would have
> otherwise UNDEF'd at EL1, and KVM would have never seen it. You cannot
> deviate from the rule of architecture, and userspace feels like the
> wrong place to enforce it.

There are multiple viable options user space has:

   1) Trigger an external abort
   2) Emulate the instruction in user space
   3) Inject a PV mechanism into the guest to emulate the insn inside 
guest space

Why should we treat 1) any different from 2) or 3)? Why is there a "fast 
path" for the external abort, on an exit that is not performance 
critical or has any other reason to get special attention from kernel 
space. All we're doing is add more code in a privileged layer for a case 
that realistically should never occur in the first place.


Alex



Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Ralf Herbrich
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
