Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96ACA51FCB0
	for <kvmarm@lists.linux.dev>; Tue, 13 Oct 2026 17:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791911130; cv=none; b=nro7mxLW2o7h1yB9GE/A3pHM+m0JJIqnoa0filGJ9sN3WlSFat5aQnmeXwVi81fZlIKqnHr57DxIzDgrXP8eoxBJnRMAcNcnVYZmZumVwxcD9QgC4t8V1wtuWYYI+TfLnDt9+JmDnru1ADbky8nF3a5yuu4djPXpmfGSIf31Fmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791911130; c=relaxed/simple;
	bh=dg4lya1wOIsNzz5d1Y0U13u79sEKc0xrgX1PBOPZf7A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=canOzTWqQtogL0ouQ/PLTygdxtS2jZNbn/8b7+rXkeDX/cX7k+cm6QEDeKp9FT+r8Z2QSThfmVZWeHqCzVkL4Ky6U/V1vLpkeopXkPgVH/JoG7JCpTT1oX0EyF1ZS3unswDCJ8qo99QVt+WPAIYWKVjOcowaAri0tWTVTONR8Z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=UPpqgxcs; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="UPpqgxcs"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 69DFF169E;
	Tue, 13 Oct 2026 10:05:23 -0700 (PDT)
Received: from gaia.lan (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3940B3F673;
	Tue, 13 Oct 2026 10:05:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791911126; bh=dg4lya1wOIsNzz5d1Y0U13u79sEKc0xrgX1PBOPZf7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UPpqgxcst0jCWD5I79N5/ZWmUnUZu8LqfLsnqqFOuKwnPlLGedZYHw488LxQU3qlv
	 uKhsgnFTvxXP25VFYW2R8Gg3HpQvubQZpQhLhycMqmTF0DkvmSss3GH/XCYQMkw89b
	 kUV1mHtu5+vBcOEpyy/dka5f7aVb041RGnjMmZOk=
From: Catalin Marinas <catalin.marinas@arm.com>
To: Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Linus Walleij <linusw@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	Usama Anjum <usama.anjum@arm.com>
Subject: Re: [PATCH v2] arm64: clear_page[s] using memset
Date: Tue, 13 Oct 2026 18:05:20 +0100
Message-ID: <179191112050.1981689.18384332389486467892.b4-ty@b4>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260916-aarch64-clear-pages-c-v2-1-0393769f7912@kernel.org>
References: <20260916-aarch64-clear-pages-c-v2-1-0393769f7912@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Wed, 16 Sep 2026 12:03:56 +0200, Linus Walleij wrote:
> There is no need to try to second-guess the compiler when
> clearing memory. Just call memset() like everyone else.
> 
> Since memset() already has an architecture-local MOPS
> optimization, we do not need to do anything else to preserve
> the MOPS optimization.
> 
> [...]

Applied to arm64 (for-next/misc), thanks!

[1/1] arm64: clear_page[s] using memset
      https://git.kernel.org/arm64/c/7fa0d9b2ec07
