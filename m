Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDD9A48424C;
	Thu, 23 Jul 2026 16:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784823085; cv=none; b=s7USACIumu0FrMYVHWl3vB4W+fa/v89eo0Lo4YZjJ+1Nqb9JTu082KclGUkZRcihEhNZswImiNg71XNMkNGvli6DR45usdEhiqnKsr1EE+/Pp7jUItwBvs3h1XCTyPCLWxlTiouaTrtLco6hEfRAVGsr0KWFk0RR5XGP4uRNRys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784823085; c=relaxed/simple;
	bh=iZYBXuf6aPeYH0iQIJnSeQhAlcl3XNy4P0DxzE1M3nc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sBQROOHtsyhdKcrzcz/neEXBKrYUZb0gWR9YfCQUV66Zbq2pfTRZXSRtE3aOACKtQkU3zpRyeyG+O75D1dDz0iFVXYtN6wUTiIhMN4BL6/GRW7jVrVfS9YU1ek+yLBvLH2FIxk4SyCKV83Pe1xKOpSzxNBC9WB0T/ruqu6UTcVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E70F51F00A3A;
	Thu, 23 Jul 2026 16:11:23 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wmw0s-0000000872c-3fEC;
	Thu, 23 Jul 2026 16:11:10 +0000
From: Marc Zyngier <maz@kernel.org>
To: Oliver Upton <oupton@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	D Scott Phillips <scott@os.amperecomputing.com>
Cc: Mark Rutland <mark.rutland@arm.com>,
	Zeng Heng <zengheng4@huawei.com>,
	Wei Xu <xuwei5@hisilicon.com>,
	Vladimir Murzin <vladimir.murzin@arm.com>,
	Lucas Wei <lucaswei@google.com>,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Sascha Bischoff <Sascha.Bischoff@arm.com>,
	Yicong Yang <yangyicong@hisilicon.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH v2] KVM: arm64: vgic: Avoid double-deactivate of IRQs in the nested context.
Date: Thu, 23 Jul 2026 17:11:07 +0100
Message-ID: <178482303767.3351010.4100459132454242259.b4-ty@b4>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260714231158.496808-1-scott@os.amperecomputing.com>
References: <20260714231158.496808-1-scott@os.amperecomputing.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: oupton@kernel.org, catalin.marinas@arm.com, will@kernel.org, corbet@lwn.net, skhan@linuxfoundation.org, joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, scott@os.amperecomputing.com, mark.rutland@arm.com, zengheng4@huawei.com, xuwei5@hisilicon.com, vladimir.murzin@arm.com, lucaswei@google.com, kuninori.morimoto.gx@renesas.com, Sascha.Bischoff@arm.com, yangyicong@hisilicon.com, yeoreum.yun@arm.com, linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Tue, 14 Jul 2026 16:11:58 -0700, D Scott Phillips wrote:
> In the nested state, the physical interrupt has already been
> deactivated through the HW bit in the LR. The extra deactivation
> would be harmless but can hit an errata case on AmpereOne, so
> avoid it here.
> 
> On AmpereOne, deactivating a physical interrupt through
> ICC_DIR_EL1 or ICC_EOIR1_EL1 (depending on EOImode) which is not
> active, but is the highest priority pending interrupt causes the
> cpu to lose the interrupt pending state and also prevents the
> delivery of future interrupts.
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: arm64: vgic: Avoid double-deactivate of IRQs in the nested context.
      commit: 8a570b19b4b16a8a3b5ffa2b332bd5613110b2d8

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


