Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B42E7343D6A;
	Wed, 12 Nov 2025 18:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762972396; cv=none; b=QcefIoM5Ov+rDPTethK/u5Rg8hccmiiBKMAzXoJfwOg55PW+e47X/+MJBpuMQe1UWpxxIYZvszdue718Gla2Xt3LJ+j8Bxe4OCsO9QD5aNjYt1W+KDM04gtelRaZMXYnfqMuJB5Pmz62ChdY2qUrd7OpiA+Zul1xrx1VjsGvEJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762972396; c=relaxed/simple;
	bh=YaM4MitBaEoWYE2OAO4lEQ4UZhqNzLI+jlRBaovkzmg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qdmQJKfLn6ywYxsVzJF6no6t037ZaJXki4pMdKrMFmEwXx+9pKAN2Nc/TgfKwM5SkW5GiYsoTVH50R83R3ZbRbwrItZ9AA67pdjII562qf26Rr3fwqgq1/vmKWl3QV6rxHlDGfWLC8792G40i09UOfM4yhLIkilns4jb7skIJiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hoXrSCZS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hoXrSCZS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05000C4AF09;
	Wed, 12 Nov 2025 18:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762972396;
	bh=YaM4MitBaEoWYE2OAO4lEQ4UZhqNzLI+jlRBaovkzmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hoXrSCZS9Xf3fBk2X+DXNK8EP3lPIENztViVu3zCYEb/92xGlmw1je8RnrgQHKPut
	 f2/vW474pdSQZbkzFol/e0IrvRm2QZOlbxlQ72NQZyOJCrHwErPjOb1y6ARFmgdBM9
	 HVRo5UDuOEZT2Mju3v+TcGJqHJEx/j2zTu7Ad14+wormbA5LhfTG5jRka7PO2Wg9OA
	 o6L3Vy4ZPldDQldQXxcj1D4dX0EP1hP8tUHh/D5g3IJsJkzwTIXxlo87rqBBbkHcRC
	 b/aNs2Ha02pL14WnO8vO92lPNgR5pAkwrpDcF8E1E94ZqGoyKF/jHgybtZCS7bV0ea
	 /evGeUraqX40g==
From: Catalin Marinas <cmarinas@kernel.org>
To: rostedt@goodmis.org,
	mhiramat@kernel.org,
	will@kernel.org,
	maz@kernel.org,
	oliver.upton@linux.dev,
	Bo Liu <liubo03@inspur.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH] arm64: Fix double word in comments
Date: Wed, 12 Nov 2025 18:33:00 +0000
Message-ID: <176297238094.2053466.1065029098279843692.b4-ty@arm.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251029071742.17732-1-liubo03@inspur.com>
References: <20251029071742.17732-1-liubo03@inspur.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

From: Catalin Marinas <catalin.marinas@arm.com>

On Wed, 29 Oct 2025 15:17:42 +0800, Bo Liu wrote:
> Remove the repeated word "the" in comments.

Applied to arm64 (for-next/typos), thanks!

[1/1] arm64: Fix double word in comments
      https://git.kernel.org/arm64/c/337f7e3a4b4d

-- 
Catalin

