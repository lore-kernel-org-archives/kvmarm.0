From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 2/3] arm/arm64: speed up spinlocks and atomic ops
Date: Thu, 25 Jun 2015 18:23:48 +0200
Message-ID: <558C2B14.7060807@redhat.com>
References: <1435248739-25425-1-git-send-email-drjones@redhat.com> <1435248739-25425-3-git-send-email-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1435248739-25425-3-git-send-email-drjones@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: christoffer.dall@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu



On 25/06/2015 18:12, Andrew Jones wrote:
> spinlock torture tests made it clear that checking mmu_enabled()
> every time we call spin_lock is a bad idea. As most tests will
> want the MMU enabled the entire time, then just hard code
> mmu_enabled() to true. Tests that want to play with the MMU can
> be compiled with CONFIG_MAY_DISABLE_MMU to get the actual check
> back.

This doesn't work if you compile mmu.o just once.  Can you make
something like

static inline bool mmu_enabled(void)
{
	return disabled_mmu_cpu_count == 0 || __mmu_enabled();
}

...

bool __mmu_enabled(void)
{
	struct thread_info *ti = current_thread_info();
	return cpumask_test_cpu(ti->cpu, &mmu_enabled_cpumask);
}

?

Paolo
