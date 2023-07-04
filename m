Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D011612C
	for <kvmarm@lists.linux.dev>; Tue,  4 Jul 2023 13:41:46 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E97351480;
	Tue,  4 Jul 2023 06:42:22 -0700 (PDT)
Received: from bogus (e103737-lin.cambridge.arm.com [10.1.197.49])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9523B3F663;
	Tue,  4 Jul 2023 06:41:38 -0700 (PDT)
Date: Tue, 4 Jul 2023 14:41:36 +0100
From: Sudeep Holla <sudeep.holla@arm.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: maz@kernel.org, oliver.upton@linux.dev,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, tabba@google.com, qperret@google.com,
	will@kernel.org, catalin.marinas@arm.com, yuzenghui@huawei.com,
	suzuki.poulose@arm.com, james.morse@arm.com, bgardon@google.com,
	gshan@redhat.com
Subject: Re: [PATCH v3] KVM: arm64: Use BTI for nvhe
Message-ID: <20230704134136.a5znw4jupt5yp5kg@bogus>
References: <20230530150845.2856828-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230530150845.2856828-1-smostafa@google.com>

On Tue, May 30, 2023 at 03:08:45PM +0000, Mostafa Saleh wrote:
> CONFIG_ARM64_BTI_KERNEL compiles the kernel to support ARMv8.5-BTI.
> However, the nvhe code doesn't make use of it as it doesn't map any
> pages with Guarded Page(GP) bit.
> 
> kvm pgtable code is modified to map executable pages with GP bit
> if BTI is enabled for the kernel.
> 
> At hyp init, SCTLR_EL2.BT is set to 1 to match EL1 configuration
> (SCTLR_EL1.BT1) set in bti_enable().
> 
> One difference between kernel and nvhe code, is that the kernel maps
> .text with GP while nvhe maps all the executable pages, this makes
> nvhe code need to deal with special initialization code coming from
> other executable sections (.idmap.text).
> For this we need to add bti instruction at the beginning of
> __kvm_handle_stub_hvc as it can be called by  __host_hvc through
> branch instruction(br) and unlike SYM_FUNC_START, SYM_CODE_START
> doesn’t add bti instruction at the beginning, and it can’t be modified
> to add it as it is used with vector tables.
> Another solution which is more intrusive is to convert
> __kvm_handle_stub_hvc to a function and inject “bti jc” instead of
> “bti c” in SYM_FUNC_START
>

I was chasing a bug in linux-next yesterday with protected nVHE(pKVM) and
cpuidle enabled. The system fails to boot. I just bisected the issue to this
patch and also saw this patch landed in the linus tree yesterday/today.
Not sure if this is something to do with the fact that pKVM skips to
__kvm_handle_stub_hvc in __host_hvc.

Let me know if you want be to try something.

-- 
Regards,
Sudeep
