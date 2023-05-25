Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4859D101DA
	for <kvmarm@lists.linux.dev>; Thu, 25 May 2023 18:25:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1650CC433D2;
	Thu, 25 May 2023 18:25:23 +0000 (UTC)
From: Catalin Marinas <catalin.marinas@arm.com>
To: Will Deacon <will@kernel.org>,
	Arnd Bergmann <arnd@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Ard Biesheuvel <ardb@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Kees Cook <keescook@chromium.org>,
	Suren Baghdasaryan <surenb@google.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-efi@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH 00/15] arm64: address -Wmissing-prototype warnings
Date: Thu, 25 May 2023 19:25:22 +0100
Message-Id: <168503901731.1110505.94060573745937753.b4-ty@arm.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230516160642.523862-1-arnd@kernel.org>
References: <20230516160642.523862-1-arnd@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Tue, 16 May 2023 18:06:27 +0200, Arnd Bergmann wrote:
> This addresses all arm64 specific protype warnings. As with the arm32
> patches, the majority of them  should be straightforward, either adding
> an #include statement to get the right header, or ensuring that an unused
> global function is left out of the build when the prototype is hidden.
> 
> The ones that are a bit awkward are those that just add a prototype to
> shut up the warning, but the prototypes are never used for calling the
> function because the only caller is in assembler code. I tried to come
> up with other ways to shut up the compiler, and ideally this would be
> triggered by the 'asmlinkage' keyword as Ard suggested in the past, but
> I could not come up with a way to do this.
> 
> [...]

Applied to arm64 (for-next/missing-proto-warn), thanks!

[01/15] arm64: xor-neon: mark xor_arm64_neon_*() static
        https://git.kernel.org/arm64/c/320a93d4df48
[02/15] arm64: add scs_patch_vmlinux prototype
        https://git.kernel.org/arm64/c/aea197160d74
[03/15] arm64: avoid prototype warnings for syscalls
        https://git.kernel.org/arm64/c/6ac19f96515e
[04/15] arm64: move cpu_suspend_set_dbg_restorer() prototype to header
        https://git.kernel.org/arm64/c/ec3a3db7100d
[05/15] arm64: spectre: provide prototypes for internal functions
        https://git.kernel.org/arm64/c/010089e9d3fe
[06/15] arm64: kvm: add prototypes for functions called in asm
        https://git.kernel.org/arm64/c/05d557a5cf59
[07/15] arm64: cpuidle: fix #ifdef for acpi functions
        https://git.kernel.org/arm64/c/68a879b55346
[08/15] arm64: efi: add efi_handle_corrupted_x18 prototype
        https://git.kernel.org/arm64/c/fbc0cd6f6044
[09/15] arm64: hide unused is_valid_bugaddr()
        https://git.kernel.org/arm64/c/b925b4314c91
[10/15] arm64: module-plts: inline linux/moduleloader.h
        https://git.kernel.org/arm64/c/60a0aab7463e
[11/15] arm64: flush: include linux/libnvdimm.h
        https://git.kernel.org/arm64/c/1a1183938946
[12/15] arm64: kaslr: add kaslr_early_init() declaration
        https://git.kernel.org/arm64/c/a7f5cb606e99
[13/15] arm64: signal: include asm/exception.h
        https://git.kernel.org/arm64/c/8ada7aab02ee
[14/15] arm64: move early_brk64 prototype to header
        https://git.kernel.org/arm64/c/e13d32e99264
[15/15] arm64: add alt_cb_patch_nops prototype
        https://git.kernel.org/arm64/c/c152aed4dcc2

-- 
Catalin

