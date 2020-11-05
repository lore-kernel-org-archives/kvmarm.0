Return-Path: <SRS0=1Hfd=EL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F921C388F7
	for <kvmarm@archiver.kernel.org>; Thu,  5 Nov 2020 11:42:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3474120A8B
	for <kvmarm@archiver.kernel.org>; Thu,  5 Nov 2020 11:42:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="JQCvVnUy"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3474120A8B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5BACD4B742;
	Thu,  5 Nov 2020 06:42:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PT53jIw9aUV3; Thu,  5 Nov 2020 06:42:15 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 51BB74B738;
	Thu,  5 Nov 2020 06:42:15 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 830CA4B738
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Nov 2020 06:42:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UKmwwQG3yS4B for <kvmarm@lists.cs.columbia.edu>;
 Thu,  5 Nov 2020 06:42:12 -0500 (EST)
Received: from mail-wm1-f68.google.com (mail-wm1-f68.google.com
 [209.85.128.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 851814B59A
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Nov 2020 06:42:12 -0500 (EST)
Received: by mail-wm1-f68.google.com with SMTP id c16so1289996wmd.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 05 Nov 2020 03:42:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=UlBOV3zJkzSNJ5Hx+un+t0ofIXF1FY2bdal7ui3TmrQ=;
 b=JQCvVnUyDY++8EPAK3PltIL4kAc552pzdGG62TSPCpuoWv6lRkoZK00Rj8Kg/Thrlx
 ciFqHvXXCZo2oR816dybbQ3A721s9DtYQQV8egFN9QUS/rilnHKiLgo2g2U9NHvdyqNw
 UcJXT3oVXmPSmJQ+HDdFLPd3rL04HpUr8PNt4UJoUSsIrf/Yo7BIx1Xw9JL3d3uVOj5m
 9EF74NYdK6N/pIdrNVUypnwtr/5CWHMM0IUC1I5Ms5WFb6ocxYElyWwLaBekxm/FN3a1
 XIOMLBHXLr60H2VD66l72onza4y6FSMASR2GhtcrYmeNwYGtb8CpQ1GANwwrhUTIr57u
 VszQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=UlBOV3zJkzSNJ5Hx+un+t0ofIXF1FY2bdal7ui3TmrQ=;
 b=Q5FbpYTleP99NduewqeudQWtzdLmqNdxjbMy5hCIYcaE2FZ+E4MyAhoAKcrfLwCE3i
 Ss0zdbYVx29YkxulEtIfLWUPZBJfBeLpI4/+rXQYffcz3T/Dgfkfq+A6mNlCsAQyFjOn
 ugf1W87Ymvf7YnKSCVtUaHak504N5YT6lLFP2bqTeEtWNdVsJq4Tnj4XzeO/spy65u97
 rI5ne44bJn5sGoWJS7IL5c9BodeOlOn6+BqF7B9hChDY9H1dcBpCraHxhu2uGmB1g7TG
 A+JvidwfAbJKGUbcNf61DFheDB5LT65wwJHkRvpVibHNmcQybeIP3xsvhG1VKp0Eri+y
 mBTA==
X-Gm-Message-State: AOAM531uE4Ko3p4NfvJHaiiJUcFVRw8w53+U3CxTb7Rim5wLHHHJfXrz
 ZO+FJx81t+hIBBTkkc74a3g5KA==
X-Google-Smtp-Source: ABdhPJxvXeNF5tLA8W/eK+ie2mfT2/1jb7zbngwpSOYKP34eOhwP+mavGJd683gYWozytkAtoWfmnA==
X-Received: by 2002:a1c:f417:: with SMTP id z23mr2181938wma.57.1604576531373; 
 Thu, 05 Nov 2020 03:42:11 -0800 (PST)
Received: from google.com ([2a01:4b00:8523:2d03:64da:f1d0:8ee7:66f5])
 by smtp.gmail.com with ESMTPSA id n6sm2135503wrj.60.2020.11.05.03.42.10
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 05 Nov 2020 03:42:10 -0800 (PST)
Date: Thu, 5 Nov 2020 11:42:09 +0000
From: David Brazdil <dbrazdil@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [RFC PATCH 18/26] kvm: arm64: Intercept PSCI_CPU_OFF host SMC
 calls
Message-ID: <20201105114209.7d3tm2w26r5mzgao@google.com>
References: <20201104183630.27513-1-dbrazdil@google.com>
 <20201104183630.27513-19-dbrazdil@google.com>
 <0ebade5427b2d9a020cd33da64cb9d13@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <0ebade5427b2d9a020cd33da64cb9d13@kernel.org>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, kernel-team@android.com,
 Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Tejun Heo <tj@kernel.org>,
 Dennis Zhou <dennis@kernel.org>, Christoph Lameter <cl@linux.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu
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

Hi Marc,

> > +static DEFINE_PER_CPU(hyp_spinlock_t, psci_cpu_lock);
> >  DEFINE_PER_CPU(enum kvm_nvhe_psci_state, psci_cpu_state);
> > 
> >  static u64 get_psci_func_id(struct kvm_cpu_context *host_ctxt)
> > @@ -76,9 +79,32 @@ static __noreturn unsigned long
> > psci_forward_noreturn(struct kvm_cpu_context *ho
> >  	hyp_panic(); /* unreachable */
> >  }
> > 
> > +static int psci_cpu_off(u64 func_id, struct kvm_cpu_context *host_ctxt)
> > +{
> > +	hyp_spinlock_t *cpu_lock = this_cpu_ptr(&psci_cpu_lock);
> > +	enum kvm_nvhe_psci_state *cpu_power = this_cpu_ptr(&psci_cpu_state);
> > +	u32 power_state = (u32)host_ctxt->regs.regs[1];
> > +	int ret;
> > +
> > +	/* Change the recorded state to OFF before forwarding the call. */
> > +	hyp_spin_lock(cpu_lock);
> > +	*cpu_power = KVM_NVHE_PSCI_CPU_OFF;
> > +	hyp_spin_unlock(cpu_lock);
> 
> So at this point, another CPU can observe the vcpu being "off", and issue
> a PSCI_ON, which may result in an "already on". I'm not sure this is an
> actual issue, but it is worth documenting.
> 
> What is definitely missing is a rational about *why* we need to track the
> state of the vcpus. I naively imagined that we could directly proxy the
> PSCI calls to EL3, only repainting PC for PSCI_ON.

I think I've solved that particular problem by *not* using cpu_power for
AFFINITY_INFO. It's used only for resolving the race between CPU_ON/OFF.
You are, however, right that perhaps that is not needed either and resolving
the race should be left to the host. In that case the hypervisor would be just
repainting the CPU_ON/SUSPEND args, as you said.

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
