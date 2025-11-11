Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF5BC3346B9;
	Tue, 11 Nov 2025 20:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762892214; cv=none; b=Q+rq6OYRfh+3WrREs2xZ+ZAhQqis0ikPsILXwIko/NfITrldzjTFsLGHkbW01/tCu7j/FUgTq0NFyWbwrzqVwLh5hXHxrU60wLPVOMPiiWykXhw4EvMcTWB23lCQA6t5Bkau/mOe2zS7pfOezI5v1yHiZvzMA1oVVtcA+PTHhbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762892214; c=relaxed/simple;
	bh=X1Ru+sy/PTv/YTjD57aE9u0CaQ0YWmBgrX+s88UhKAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=C2Jwrix4iJUpUesAKjw/r5Gwk7TnXgBVNj7jLeTRVkiQvl4EkmplLUKGa+Jm6dPOHHrBMTM9iAZXgjT3xTE00d5G2XEZGGJbxKF1fcTOOHBrKN+nHRNPOsCnO+csx4oRFqr1nDsgAY2YTk33g0jyrrnBffLdByOq+0DceSidMN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7EB9C116B1;
	Tue, 11 Nov 2025 20:16:52 +0000 (UTC)
From: Catalin Marinas <catalin.marinas@arm.com>
To: Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Thomas Huth <thuth@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH v2 0/2] arm64: Replace __ASSEMBLY__ with __ASSEMBLER__ in headers
Date: Tue, 11 Nov 2025 20:16:35 +0000
Message-ID: <176289219516.1641900.16581648877068105161.b4-ty@arm.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251010130116.828465-1-thuth@redhat.com>
References: <20251010130116.828465-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Fri, 10 Oct 2025 15:01:14 +0200, Thomas Huth wrote:
> The kernel Makefiles define the __ASSEMBLY__ macro to provide
> a way to use headers in both, assembler and C source code.
> However, all the supported versions of the GCC and Clang compilers
> also define the macro __ASSEMBLER__ automatically already when compiling
> assembler code, so some kernel headers are using __ASSEMBLER__ instead.
> With regards to userspace code, this seems also to be constant source
> of confusion, see for example these links here:
> 
> [...]

Applied to arm64 (for-next/assembler-macro), thanks!

[1/2] arm64: Replace __ASSEMBLY__ with __ASSEMBLER__ in uapi headers
      https://git.kernel.org/arm64/c/639f08fc20c9
[2/2] arm64: Replace __ASSEMBLY__ with __ASSEMBLER__ in non-uapi headers
      https://git.kernel.org/arm64/c/287d163322b7

-- 
Catalin

