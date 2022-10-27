Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F77BFA3740
	for <kvmarm@archiver.kernel.org>; Thu, 27 Oct 2022 17:24:44 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 103B343C96;
	Thu, 27 Oct 2022 13:24:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vq9f+m8FPF1R; Thu, 27 Oct 2022 13:24:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CAD4840B75;
	Thu, 27 Oct 2022 13:24:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F30C2404FD
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Oct 2022 13:24:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Et-S38og+wjm for <kvmarm@lists.cs.columbia.edu>;
 Thu, 27 Oct 2022 13:24:40 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CB57E4040B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Oct 2022 13:24:40 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 1A4E6B826F9;
 Thu, 27 Oct 2022 17:24:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C88ACC433B5;
 Thu, 27 Oct 2022 17:24:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1666891477;
 bh=5fx+7t9++1F1VmB8YaQOGyc/rEsxRR+nOp2+GO8srUM=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=EjbVZwgYYZ3rD5ChDt9vFEOn8hQQ3wgTRDB9mFDU451EbcSaH88wWDfiPGr5UmsOk
 YVGSyKHnjSjP9A887RPB+cLb8MgH0BPdhlLKckjhc4Mds6EAqiyzBCz71cQCDwBvV3
 1Q1ic228xwN/tKvuuJanwb+boD5U8hK74sVNLSjxFrKSAkRrVfqKHZhz0DVRMn3+q8
 ot5npOmonBSKZBDzEQd41RrrUhDFMvxJ3BiYUY3ejUWjesEBHjfOFlj2tGZiUuEvIk
 oQ6BnVNdjF6p3aBL7UKjEEl7j0g9PEDK/NCnifKatFvZTOUhBen+KLdWEn8+viUBVY
 8O8VHgrSLlwaQ==
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1oo6cN-0023RF-JP;
 Thu, 27 Oct 2022 18:24:35 +0100
MIME-Version: 1.0
Date: Thu, 27 Oct 2022 18:24:35 +0100
From: Marc Zyngier <maz@kernel.org>
To: Reiji Watanabe <reijiw@google.com>
Subject: Re: [PATCH 6/9] KVM: arm64: PMU: Move the ID_AA64DFR0_EL1.PMUver
 limit to VM creation
In-Reply-To: <CAAeT=FwFS+oTG3Q0sDMyobfQst2TWUqyU4XQFmmELPS1rwp96w@mail.gmail.com>
References: <20220805135813.2102034-1-maz@kernel.org>
 <20220805135813.2102034-7-maz@kernel.org>
 <CAAeT=FzXyr7D24QCcwGckgnPFuo8QtN3GrPg9h+s+3uGETE9Dw@mail.gmail.com>
 <CAAeT=FxheB7HKFxyZwE8LJSjRzxRXQYb7_uQYF9o1hMV6Dow-g@mail.gmail.com>
 <86k04mejd0.wl-maz@kernel.org>
 <CAAeT=FwFS+oTG3Q0sDMyobfQst2TWUqyU4XQFmmELPS1rwp96w@mail.gmail.com>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <989ec7a63aff44e5fe2d85f691a7f330@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: reijiw@google.com, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
 Linux ARM <linux-arm-kernel@lists.infradead.org>, kvm@vger.kernel.org
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

On 2022-10-27 17:09, Reiji Watanabe wrote:
>> I think that with this patch both PMUVer and Perfmon values get set to
>> 0 (pmuver_to_perfmon() returns 0 for both ID_AA64DFR0_PMUVER_IMP_DEF
>> and no PMU at all). Am I missing anything here?
> 
> When pmuver_to_perfmon() returns 0 for ID_AA64DFR0_PMUVER_IMP_DEF,
> cpuid_feature_cap_perfmon_field() is called with 'cap' == 0.  Then,
> the code in cpuid_feature_cap_perfmon_field() updates the 'val' with 0
> if the given 'features' (sanitized) value is 
> ID_AA64DFR0_PMUVER_IMP_DEF.
> So, now the val(== 0) is not larger than the cap (== 0), and
> cpuid_feature_cap_perfmon_field() ends up returning the given 
> 'features'
> value as it is without updating the PERFMON field.

Ah, thanks for spelling it out for me, I was definitely looking
at the wrong side of things. You're absolutely right. The code
I have now makes sure to:

(1) preserve the IMP_DEF view of the PMU if userspace provides
     such setting

(2) directly places the emulated PMU revision in the feature
     set without calling cpuid_feature_cap_perfmon_field(),
     which indeed does the wrong thing.

Hopefully I got it right this time! ;-)

Thanks again,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
