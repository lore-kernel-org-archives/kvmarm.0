Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F35E2A1BF;
	Wed, 21 May 2025 14:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747836043; cv=none; b=kdTCENC7AzR9+1/SJ8h8YRCOkXp95G0Q0YxkcwLG7XtpLlmZ4MnUDDUoIRcOlufGHmh1kOjkbL9wM3+TILaMZG+ufaHjaP5LDEYsX0jT7z/Q5j0Ko0diQ2japa4y0ADUTbNcgfcx0RG7hXuTOevPDRkVjsF9d+KX0mAGKvyVaTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747836043; c=relaxed/simple;
	bh=TG7KGt9Z8KkHwG8PtZech7PK1ytDELh9NZgI+4R2pzI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fPqi0J9ceAmpT0mOvAbu4fwL2Jem9KmiCiwjTRtUfcWP4jC5oV6O0lJmYW78nXLDiRYlqyZPS+b5eD4U8gtxonifwKnU+8h2IPkygRZP7ePlFXiAtJ3yS4YBp9OIVZgEZLZ2f5ZjxhbTPKVxqiOmR1ulUFIuq6S7lq/c5aUr+bk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KbALZD/d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KbALZD/d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7F81C4CEE4;
	Wed, 21 May 2025 14:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747836043;
	bh=TG7KGt9Z8KkHwG8PtZech7PK1ytDELh9NZgI+4R2pzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KbALZD/dEscVsNoTk46Tney3bpr9YBapbD6kPiCrP6jYQVYeU1B+lRBw0hGJnMIxA
	 fxhEojnMsplG0brkRHU0kGSzA5rdSej0MtquM4ljjzCMg9FPzyYqsj6CWuJ/qtqwNZ
	 Fxb8yRoc6SMYtWQIldMJI9Zxjot0qbS9IkvzCHwhM3q4XLQ5WEcKQCHFerrp3fdCfc
	 dqxQN6LjTj71cn1owXAGH822pLzILvFd4FnLld/oIDJrS/AXKscTyAjPwLxBMi4rER
	 bDKJdtaZftPXqHhCUJEqVAWvWy2P/P3VNs41LeT1kV9IV/+5Ic94ygZ6pgDCKo4vnM
	 RoY6vcigApi+w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1uHjzs-00Gxn5-Mt;
	Wed, 21 May 2025 15:00:40 +0100
From: Marc Zyngier <maz@kernel.org>
To: oliver.upton@linux.dev,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	Vincent Donnefort <vdonnefort@google.com>
Cc: qperret@google.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kernel-team@android.com
Subject: Re: [PATCH v6 00/10] Stage-2 huge mappings for pKVM np-guests
Date: Wed, 21 May 2025 15:00:36 +0100
Message-Id: <174783602755.119525.10800483609741009182.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250521124834.1070650-1-vdonnefort@google.com>
References: <20250521124834.1070650-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, vdonnefort@google.com, qperret@google.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Wed, 21 May 2025 13:48:24 +0100, Vincent Donnefort wrote:
> This series adds support for stage-2 huge mappings (PMD_SIZE) to pKVM
> np-guests, that is installing PMD-level mappings in the stage-2,
> whenever the stage-1 is backed by either Hugetlbfs or THPs.
> 
> The last patch of that series is an optimization for CMOs using a shared
> PMD_SIZE fixmap.
> 
> [...]

Applied to next, thanks!

[01/10] KVM: arm64: Handle huge mappings for np-guest CMOs
        commit: 944a1ed8cc3ea6c5b16b6aca11475ced0daf68a9
[02/10] KVM: arm64: Introduce for_each_hyp_page
        commit: 3db771fa23ed6aecdf28ce4b806309198eea84e2
[03/10] KVM: arm64: Add a range to __pkvm_host_share_guest()
        commit: 4274385ebf090461b46b9bddb0f7c526182ba3c0
[04/10] KVM: arm64: Add a range to __pkvm_host_unshare_guest()
        commit: f28f1d02f4eaac05c2ad6bf7264a8696dc21d011
[05/10] KVM: arm64: Add a range to __pkvm_host_wrprotect_guest()
        commit: 0eb802b3b4ecfb10046bc325f47e7fd741c72ffe
[06/10] KVM: arm64: Add a range to __pkvm_host_test_clear_young_guest()
        commit: c4d99a833d34d8041a568f0c076379ae53c47896
[07/10] KVM: arm64: Convert pkvm_mappings to interval tree
        commit: b38c9775f73941ee59aebc0a489aa5c22e632def
[08/10] KVM: arm64: Add a range to pkvm_mappings
        commit: 3669ddd8fa8b5a46d96b9c54a6fa519a17e4a4fa
[09/10] KVM: arm64: Stage-2 huge mappings for np-guests
        commit: db14091d8f75852d960b18834c7bdb1b7c2bb74f
[10/10] KVM: arm64: np-guest CMOs with PMD_SIZE fixmap
        commit: c353fde17d8f7e710884532da50393cd22ddbfbe

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


