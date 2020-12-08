Return-Path: <SRS0=0wdR=FM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.7 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FSL_HELO_FAKE,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EFD4C433FE
	for <kvmarm@archiver.kernel.org>; Tue,  8 Dec 2020 10:08:39 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D96B423A84
	for <kvmarm@archiver.kernel.org>; Tue,  8 Dec 2020 10:08:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D96B423A84
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3AC954B25F;
	Tue,  8 Dec 2020 05:08:38 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mafoO3ntTkSb; Tue,  8 Dec 2020 05:08:37 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 11A254B1DC;
	Tue,  8 Dec 2020 05:08:37 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 062F14B1DC
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Dec 2020 05:08:35 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nFdRB3nwjfA6 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Dec 2020 05:08:33 -0500 (EST)
Received: from mail-wr1-f66.google.com (mail-wr1-f66.google.com
 [209.85.221.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A51964B1CE
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Dec 2020 05:08:33 -0500 (EST)
Received: by mail-wr1-f66.google.com with SMTP id c1so3679137wrq.6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 08 Dec 2020 02:08:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=AZ1JoaEugH2kZjiM+1q8p4p22cxzbXAaz18ICTGEw5w=;
 b=i8dF9UQdWs6QIpFpplKtGnT0gZMxooWKlGoQwA9Pl9IGUpXvDUntpDIWxBzAhlVS1G
 VSf06k+DRZQ9MylRwjBygEtv0u8c0WIPa4EmRcGnuaN8/MsrwcmKV1BBeT/xFC+LhOz1
 2ahcumv86T0qh7CJ9zR9ZNuLCrPMhokFUByDr0SZZGVTkA3fXFBtQ25SiRZstVoqET+B
 5jR2XRO76aMCn5LBpgMH6DVgEZOuLeYjiyncb7nUFhdWi9gNieHrGwE1KEl6oX0J30TY
 d/AF9zdhTEEpUbKePFmY6n30mQd9I89QNzZXNModfQwwp6yk2GuilYZvkro+HwL37V98
 vOCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=AZ1JoaEugH2kZjiM+1q8p4p22cxzbXAaz18ICTGEw5w=;
 b=gYQEm4AyW+Dj3zSoyJncaYGcyk2FVheZxWUvn/5TK4o8I8+yeZvReB6CejtVS4glrX
 x85tDaPwNsf86qihyntZDZxaNJIq9OGEsPNVgAh/AW1KxLfNu4xf6pwv/Ib35BdAKOJu
 LTkbSkkw9Y4jnwyJyeO2YA187Cfz9eQt02r+mSyuZnVWM/pjollD/CB19zLK7hKezl3j
 5WSczUj7E14K+Oiu6BnJEAoVIpB7e+Ri255aFq3WkBf4jevzcMFP55OlzW862mEpJasp
 b4bzG/v4Z8pRtJVWau0t2ac2K5FNbenQ5+w1jjEKvNX9oLz4RQkbRAhS8Z4pauENTCov
 AYWw==
X-Gm-Message-State: AOAM533cUJYLPL10Kkd+sMOoP5J6dcooAGThLuJD9MqN53umumsUYi06
 TS4GLHlzGNFIm3i40oC68bNA0g==
X-Google-Smtp-Source: ABdhPJx0/5YZtTz2GMggQZzAzXjM+OSm7kqbGZ6gvhOEG4D5YV1WkhrI2ITa8y8DL0W4HS9m5064iA==
X-Received: by 2002:a5d:610d:: with SMTP id v13mr24415607wrt.425.1607422112519; 
 Tue, 08 Dec 2020 02:08:32 -0800 (PST)
Received: from google.com ([2a01:4b00:8523:2d03:258e:cb26:cef:a620])
 by smtp.gmail.com with ESMTPSA id q73sm2667566wme.44.2020.12.08.02.08.30
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 08 Dec 2020 02:08:31 -0800 (PST)
Date: Tue, 8 Dec 2020 10:08:30 +0000
From: David Brazdil <dbrazdil@google.com>
To: Qian Cai <qcai@redhat.com>
Subject: Re: [PATCH v4 17/26] kvm: arm64: Add offset for hyp VA <-> PA
 conversion
Message-ID: <20201208100830.dhkkhzsqiy46euod@google.com>
References: <20201202184122.26046-1-dbrazdil@google.com>
 <20201202184122.26046-18-dbrazdil@google.com>
 <1835d0c3d0f6024b7c6778d9d84f1120291eacad.camel@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1835d0c3d0f6024b7c6778d9d84f1120291eacad.camel@redhat.com>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Will Deacon <will@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
 Marc Zyngier <maz@kernel.org>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, Sudeep Holla <sudeep.holla@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Tejun Heo <tj@kernel.org>,
 Dennis Zhou <dennis@kernel.org>, Christoph Lameter <cl@linux.com>,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

Hi Qian,

> > +/*
> > + * Store a hyp VA <-> PA offset into a hyp-owned variable.
> > + */
> > +static void init_hyp_physvirt_offset(void)
> > +{
> > +	extern s64 kvm_nvhe_sym(hyp_physvirt_offset);
> > +	u64 kern_va, hyp_va;
> > +
> > +	/* Compute the offset from the hyp VA and PA of a random symbol. */
> > +	kern_va = (u64)kvm_ksym_ref(__hyp_text_start);
> > +	hyp_va = __early_kern_hyp_va(kern_va);
> > +	CHOOSE_NVHE_SYM(hyp_physvirt_offset) = (s64)__pa(kern_va) - (s64)hyp_va;
> 
> The code here introduced a warning on TX2 from today's linux-next.
> 
> .config: https://cailca.coding.net/public/linux/mm/git/files/master/arm64.config
> 
> [   29.356963] CPU255: Booted secondary processor 0x0000011f03 [0x431f0af1]
> [   29.358301] smp: Brought up 2 nodes, 256 CPUs
> [   29.364962] SMP: Total of 256 processors activated.
> [   29.364985] CPU features: detected: Privileged Access Never
> [   29.365003] CPU features: detected: LSE atomic instructions
> [   29.365023] CPU features: detected: CRC32 instructions
> [   29.431660] CPU: All CPU(s) started at EL2
> [   29.431685] ------------[ cut here ]------------
> [   29.431713] virt_to_phys used for non-linear address: (____ptrval____) (__hyp_idmap_text_end+0x0/0x534)
> [   29.431744] WARNING: CPU: 0 PID: 1 at arch/arm64/mm/physaddr.c:15 __virt_to_phys+0x80/0xc0
> [   29.431759] Modules linked in:
> [   29.431787] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.10.0-rc6-next-20201207+ #2
> [   29.431804] pstate: 10400009 (nzcV daif +PAN -UAO -TCO BTYPE=--)
> [   29.431819] pc : __virt_to_phys+0x80/0xc0
> [   29.431834] lr : __virt_to_phys+0x80/0xc0
> [   29.431848] sp : ffff000005fefc90
> [   29.431862] x29: ffff000005fefc90 x28: ffff8000191c9010 
> [   29.431891] x27: ffff000005f21228 x26: b14e19fe279ae3eb 
> [   29.431920] x25: ffff8000191c9010 x24: ffff8000191c9000 
> [   29.431948] x23: ffff8000191c9000 x22: 000f800011235acc 
> [   29.431975] x21: 0000000000000001 x20: 000f800000000000 
> [   29.432003] x19: ffff800011235acc x18: ffff6001cedcc336 
> [   29.432031] x17: 0000000000001308 x16: 0000000000000002 
> [   29.432058] x15: 0000000000000000 x14: 7261656e696c2d6e 
> [   29.432086] x13: ffff600000bfdee7 x12: 1fffe00000bfdee6 
> [   29.432113] x11: 1fffe00000bfdee6 x10: ffff600000bfdee6 
> [   29.432141] x9 : ffff80001020a928 x8 : ffff000005fef737 
> [   29.432169] x7 : 0000000000000001 x6 : ffff600000bfdee7 
> [   29.432196] x5 : ffff600000bfdee7 x4 : 1fffe00000bfdedc 
> [   29.432223] x3 : 1fffe00000be4009 x2 : ffff600000bfdf5c 
> [   29.432251] x1 : 8fd448c3d76ca800 x0 : 0000000000000000 
> [   29.432279] Call trace:
> [   29.432294]  __virt_to_phys+0x80/0xc0
> [   29.432312]  kvm_compute_layout+0x21c/0x264
> init_hyp_physvirt_offset at arch/arm64/kvm/va_layout.c:47
> (inlined by) kvm_compute_layout at arch/arm64/kvm/va_layout.c:82
> [   29.432327]  smp_cpus_done+0x164/0x17c
> [   29.432342]  smp_init+0xc4/0xd8
> [   29.432358]  kernel_init_freeable+0x4ec/0x734
> [   29.432375]  kernel_init+0x18/0x12c
> [   29.432391]  ret_from_fork+0x10/0x1c
> [   29.432405] irq event stamp: 490612
> [   29.432424] hardirqs last  enabled at (490611): [<ffff800010207f60>] console_unlock+0x8e0/0xca0
> [   29.432440] hardirqs last disabled at (490612): [<ffff800011212f44>] el1_dbg+0x24/0x50
> [   29.432455] softirqs last  enabled at (487946): [<ffff800010010a98>] _stext+0xa98/0x113c
> [   29.432473] softirqs last disabled at (487939): [<ffff8000100ec5e8>] irq_exit+0x500/0x5e0
> [   29.432492] ---[ end trace 96247b4cbbdf9333 ]---
> 

Thanks for the report, I've been able to reproduce with CONFIG_DEBUG_VIRTUAL=y
and the kernel running in EL2. Doesn't pose any functional issues as the results
of this are never used. I'll post a fix later today.

David


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
