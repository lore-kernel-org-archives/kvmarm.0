Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 292FF63A1
	for <kvmarm@lists.linux.dev>; Tue,  4 Jul 2023 14:18:15 +0000 (UTC)
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-3fbd200d354so216675e9.1
        for <kvmarm@lists.linux.dev>; Tue, 04 Jul 2023 07:18:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1688480294; x=1691072294;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=eS9MwUiGBcqynGVE0FeA/+dAT/8VCpi0aohdmN5v6Zg=;
        b=sCUFOvokkesjF48j8RLtdFxTj4gLtePGOpeB71O/AHp13/U4OK6wSukOxneHGZt7QP
         ugKFzsydFXJeVVKaxyqHd+973UnuqK/GYOSjd18eaYtgHEa+4ZIK2pNzEeGI3STZrX5Q
         rgA1yHTZpRfUAguLuGAxIVroUfzk8YFU5fz3RmrM13fUum0dmUaUV9wD8cr4GnOs6Ax4
         gY1dE52UpgVPUUbVsnjT47zP5rwiD551sDDd75Q/nzwAzeoYXYiBN2KBBHh5nFVcw3MN
         bfnfr7TyikfppuRMink13/KRQpXdliOKf/vDv/+mVbDejIole33v34f52tGJlWnuyS1F
         w96A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688480294; x=1691072294;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eS9MwUiGBcqynGVE0FeA/+dAT/8VCpi0aohdmN5v6Zg=;
        b=FRvMFF3i94/LEI9YiJonRvzY4bnrMtUOxpvNquGoj+UrFCZLDMPEepp3yYRz4SFZTP
         0kOkIzaTad0Jua+tAHt3VjL5HbPfHXVkHys39tqhfwNnLiI08aiY8m117dBg4nk87s3/
         qzleZQ6r6U8NOtr8rcQzC4jk3Tx79qCsHwms8IVHdvU2TpXi1iNbg1Vh/9drLu+aAiTb
         QnS9RQ4wuuj/jZhp56odzT3Lx9hMjcc3fWxAaGQvMkZWkYJr8b0nqDSLXgBdowARX/b8
         R9n7Y61oY7S/3lozk4rbTWjGZDJIE3XvRM78ZNoshvUrgEhyf7guzg5qG1KeCT1cbPld
         tkFQ==
X-Gm-Message-State: ABy/qLbOAbiSOSp72XsBUfQ6ZzeQDBeGYaWKisH+UlYA+xmk0waP9aML
	EsW9gtWxACDlh9kYjXjtNe4l6Q==
X-Google-Smtp-Source: APBJJlFy++WqAbmLwJsZUhEhnywQSW5qCv8OEwfmtYtSMRmsV+V5O1kVPJuwdWa99ShJ4T4/oUOPcg==
X-Received: by 2002:a05:600c:548d:b0:3f1:70d1:21a6 with SMTP id iv13-20020a05600c548d00b003f170d121a6mr81040wmb.0.1688480293964;
        Tue, 04 Jul 2023 07:18:13 -0700 (PDT)
Received: from google.com (44.232.78.34.bc.googleusercontent.com. [34.78.232.44])
        by smtp.gmail.com with ESMTPSA id b7-20020a5d4b87000000b00314374145e0sm5614126wrt.67.2023.07.04.07.18.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jul 2023 07:18:13 -0700 (PDT)
Date: Tue, 4 Jul 2023 14:18:09 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Sudeep Holla <sudeep.holla@arm.com>
Cc: maz@kernel.org, oliver.upton@linux.dev,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, tabba@google.com, qperret@google.com,
	will@kernel.org, catalin.marinas@arm.com, yuzenghui@huawei.com,
	suzuki.poulose@arm.com, james.morse@arm.com, bgardon@google.com,
	gshan@redhat.com
Subject: Re: [PATCH v3] KVM: arm64: Use BTI for nvhe
Message-ID: <ZKQqIYRrckLlXqkx@google.com>
References: <20230530150845.2856828-1-smostafa@google.com>
 <20230704134136.a5znw4jupt5yp5kg@bogus>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230704134136.a5znw4jupt5yp5kg@bogus>

Hi Sudeep,

On Tue, Jul 04, 2023 at 02:41:36PM +0100, Sudeep Holla wrote:
> On Tue, May 30, 2023 at 03:08:45PM +0000, Mostafa Saleh wrote:
> > CONFIG_ARM64_BTI_KERNEL compiles the kernel to support ARMv8.5-BTI.
> > However, the nvhe code doesn't make use of it as it doesn't map any
> > pages with Guarded Page(GP) bit.
> > 
> > kvm pgtable code is modified to map executable pages with GP bit
> > if BTI is enabled for the kernel.
> > 
> > At hyp init, SCTLR_EL2.BT is set to 1 to match EL1 configuration
> > (SCTLR_EL1.BT1) set in bti_enable().
> > 
> > One difference between kernel and nvhe code, is that the kernel maps
> > .text with GP while nvhe maps all the executable pages, this makes
> > nvhe code need to deal with special initialization code coming from
> > other executable sections (.idmap.text).
> > For this we need to add bti instruction at the beginning of
> > __kvm_handle_stub_hvc as it can be called by  __host_hvc through
> > branch instruction(br) and unlike SYM_FUNC_START, SYM_CODE_START
> > doesn’t add bti instruction at the beginning, and it can’t be modified
> > to add it as it is used with vector tables.
> > Another solution which is more intrusive is to convert
> > __kvm_handle_stub_hvc to a function and inject “bti jc” instead of
> > “bti c” in SYM_FUNC_START
> >
> 
> I was chasing a bug in linux-next yesterday with protected nVHE(pKVM) and
> cpuidle enabled. The system fails to boot. I just bisected the issue to this
> patch and also saw this patch landed in the linus tree yesterday/today.

One of the challenges of BTI is that we need to add explicit BTI instructions
for assembly code. I checked the code to make sure that nothing was missing,
but maybe this is not the case.
Can you please share more about the issue (is ESR a Branch Target Exception,
call stack...) if possible.
Also, is this with CONFIG_ARM_PSCI_CPUIDLE?

> Not sure if this is something to do with the fact that pKVM skips to
> __kvm_handle_stub_hvc in __host_hvc.
__kvm_handle_stub_hvc is called from __host_hvc with "br x5"
That's why "bti j" was added at the beginning of __kvm_handle_stub_hvc,
so this should be fine.

> Let me know if you want be to try something.
> 
> -- 
> Regards,
> Sudeep

Thanks,
Mostafa

