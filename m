Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82D1B325491;
	Mon, 18 May 2026 11:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779104810; cv=none; b=YyvxyRtfANYkq/fr+qkGd2+4bXF0hjv5mOzwZSLh3cQNa6Dw5teMuVyzUNqdQ3xer30u6Z3wY7IRBfs6qwD+KejYfVR3ECtSX9zO4CSZ1KQq9+iFu5d0jy6t3gJFjl4hF+u1R5I07f+btUVPuFsbmTwhxUOtU+dNpo1ywiPk0eQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779104810; c=relaxed/simple;
	bh=s3PSvVw82oZnAXr021EdW5Vt59yF93HfacTQeU7InMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bUqV3TutpBIe8/01tU2MpYSYbsi9KotIGkT+rMHBsf+VZnhLw+PQVO1RGbmu8pK73z65Cmz+bzAJKWOjRmJ5i/LvPlmS/tp5Cbb+vo5bJz1lIxZoeDsCq31b6E1wYzlRoATZAQ62Zsvzrl4XeUE0Xm9q5phOWPqkT+J1rlGxeCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QgS7GU/q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QgS7GU/q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1D95C2BCB7;
	Mon, 18 May 2026 11:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779104810;
	bh=s3PSvVw82oZnAXr021EdW5Vt59yF93HfacTQeU7InMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QgS7GU/q06K2GyLdAaMjLuzX9ITKtt0zUzh8d5qF7I+DA3eGnGetcZ4ife/t3AAw7
	 C2X3SWXpZv7rtx7crTkBL5qdmklSAvUxTuTeUf4LQKL9mf0CSjDAGjhCy+9GMkoS7T
	 I8/Qzl7NdlNrokyoK2joP2/gfYNAr+u5d3GK5f/H2ucH/+kJPZbp51rNTbSB01ZlJj
	 fKLDwdBGedU7s4IgFJFJOlBNAXEKhyPjKxqYMnlSyxwfOYl9YDateh2P8SXg9OWBVS
	 YWx5wy1hCKYmTM/FqMtMCIqRrBdICE/xtO7atKEbiFaEJLDigQ++v7fHy93bTFyXy5
	 p5JmjUoVG8haw==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.linux.dev,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: catalin.marinas@arm.com,
	kernel-team@android.com,
	Will Deacon <will@kernel.org>,
	kvm@vger.kernel.org,
	alexandru.elisei@arm.com,
	oupton@kernel.org,
	maz@kernel.org,
	tabba@google.com,
	aneesh.kumar@kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 00/17] kvmtool: arm64: Handle PSCI calls in userspace
Date: Mon, 18 May 2026 12:46:35 +0100
Message-ID: <177910301452.87599.12049766456792407695.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260330142334.3309961-1-suzuki.poulose@arm.com>
References: <20260330142334.3309961-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Mon, 30 Mar 2026 15:23:17 +0100, Suzuki K Poulose wrote:
> This is version 7 of the patch series, originally posted by Oliver [0].
> 
> Use SMCCC filtering capability in to handle PSCI calls in the userspace.
> 
> Changes since v7:
>  Link: https://lkml.kernel.org/r/20260227165624.1519865-1-suzuki.poulose@arm.com
>  - Drop linux/const.h from the list of headers updated. Retain, one time update
>    to fix the build break.
> 
> [...]

Applied to kvmtool (master), thanks!

[01/17] headers: Update linux/const.h from linux sources
        https://git.kernel.org/will/kvmtool/c/42f00a665506
[02/17] util/update_headers: Clean up header copying
        https://git.kernel.org/will/kvmtool/c/448c4dae933a
[03/17] util/update_headers: Warn about missing header files
        https://git.kernel.org/will/kvmtool/c/d26adf1f21c4
[04/17] update_headers: arm64: Track uapi/linux/psci.h for PSCI definitions
        https://git.kernel.org/will/kvmtool/c/4123e5fa3a76
[05/17] arm64: Sync headers from Linux v6.19 for psci.h
        https://git.kernel.org/will/kvmtool/c/0701c4bfe31f
[06/17] Import arm-smccc.h from Linux v6.19
        https://git.kernel.org/will/kvmtool/c/00873ec97632
[07/17] arm64: Stash kvm_vcpu_init for later use
        https://git.kernel.org/will/kvmtool/c/e7b0bde8aadc
[08/17] arm64: Use KVM_SET_MP_STATE ioctl to power off non-boot vCPUs
        https://git.kernel.org/will/kvmtool/c/8ee63ab3141a
[09/17] arm64: Expose ARM64_CORE_REG() for general use
        https://git.kernel.org/will/kvmtool/c/42b3f4dd25c2
[10/17] arm64: Add support for finding vCPU for given MPIDR
        https://git.kernel.org/will/kvmtool/c/9ba52cf92905
[11/17] arm64: Add skeleton implementation for PSCI
        https://git.kernel.org/will/kvmtool/c/210640bb395c
[12/17] arm64: psci: Implement CPU_SUSPEND
        https://git.kernel.org/will/kvmtool/c/c5a68d261f4b
[13/17] arm64: psci: Implement CPU_ON
        https://git.kernel.org/will/kvmtool/c/6e06236cf8fa
[14/17] arm64: psci: Implement AFFINITY_INFO
        https://git.kernel.org/will/kvmtool/c/2eb3c13c1a54
[15/17] arm64: psci: Implement MIGRATE_INFO_TYPE
        https://git.kernel.org/will/kvmtool/c/c1418fca53ad
[16/17] arm64: psci: Implement SYSTEM_{OFF,RESET}
        https://git.kernel.org/will/kvmtool/c/d2b1def2caa1
[17/17] arm64: smccc: Start sending PSCI to userspace
        https://git.kernel.org/will/kvmtool/c/ce79de9211ea

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
