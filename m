From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] KVM: arm/arm64: Fix PSCI affinity info return value for
 non valid cores
Date: Fri, 04 Sep 2015 16:54:53 +0100
Message-ID: <55E9BECD.6040302@arm.com>
References: <1441379184-16749-1-git-send-email-a.spyridakis@virtualopensystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1441379184-16749-1-git-send-email-a.spyridakis@virtualopensystems.com>
Sender: kvm-owner@vger.kernel.org
To: Alexander Spyridakis <a.spyridakis@virtualopensystems.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: christoffer.dall@linaro.org, a.rigo@virtualopensystems.com
List-Id: kvmarm@lists.cs.columbia.edu

On 04/09/15 16:06, Alexander Spyridakis wrote:
> If a guest requests the affinity info for a non-existing vCPU we need to
> properly return an error, instead of erroneously reporting an off state.
> 
> Signed-off-by: Alexander Spyridakis <a.spyridakis@virtualopensystems.com>
> Signed-off-by: Alvise Rigo <a.rigo@virtualopensystems.com>

Seems sound to me. Out of curiosity, how was this found?

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
