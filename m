Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91EB227FD43;
	Fri, 28 Nov 2025 18:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764355865; cv=none; b=nAAdmgVTwFRl/yeeoyEqeKIScQTxSapaRZJOY+Q0FDUhhnB3ui2FfQX5/HO50Lk8QqVqQQujZ/wg2nSUMo29xR9FWIM6D5BOVxufk6UWFugDL+YBNc9GXqK9bkJdlYXvnmlmm7uyDoNyAJLwaKzqSR3DHVVCgncYDUuk7q55hZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764355865; c=relaxed/simple;
	bh=dhHIbvpCuulxKEAkqdhlFDieD4aHu6LWLRet+FMiD5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rc3lgtGlhuTQ/8AlD/FsBsxIMShnDNSSYCy4lc1JZixAgulzTXwp/YOtR1IatVgRhzUATCUfvbDP9IrSIUBbeLvc8q2joJzrogVTsPBIYVyDSr0Zyr0ilqWvTZ8pRxTNMgnZtvUfrMdvNa/VGjdL7l8dUkfOtuwDb6cnetPnAAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mh5TT6nq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mh5TT6nq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8122C113D0;
	Fri, 28 Nov 2025 18:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764355865;
	bh=dhHIbvpCuulxKEAkqdhlFDieD4aHu6LWLRet+FMiD5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mh5TT6nqG7GLwKm/V8ednxHY2PajJrlW7e1XAzHhABnJJ7XufHgJOx+vtzS6j1MZX
	 BCoQfC9V4raW224VY6nU5sVwFM+B3KePmpxtWIXKQ6Lz+onuAb8Y1qhs0phPIlWcdg
	 eEpcSzxwO+cgN/wZ4zsTh1Z7RwJ6aLyKB5KQmHNMkx89BEo19YFBI4BytJO9RL+61X
	 0NkFHfNtN8xAW1Xqa8rpwo4jfSCbuJbroINDXPly7NaYJNwxs5UxVVO4+gH46sNA3j
	 Sj/8V9F61pnEqq31jdj2+X3GTHmQHM/dkfygwI+Cywkl/LbrXInEkSppT+lDHP9QcB
	 jDP+Wxg6QGeMQ==
From: Oliver Upton <oupton@kernel.org>
To: Marc Zyngier <maz@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Colin Ian King <colin.i.king@gmail.com>
Cc: Oliver Upton <oupton@kernel.org>,
	kernel-janitors@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] KVM: arm64: Fix spelling mistake "Unexpeced" -> "Unexpected"
Date: Fri, 28 Nov 2025 10:51:01 -0800
Message-ID: <176435583511.14290.101174161990641158.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251128175124.319094-1-colin.i.king@gmail.com>
References: <20251128175124.319094-1-colin.i.king@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Fri, 28 Nov 2025 17:51:24 +0000, Colin Ian King wrote:
> There is a spelling mistake in a TEST_FAIL message. Fix it.
> 
> 

Applied to next, thanks!

[1/1] KVM: arm64: Fix spelling mistake "Unexpeced" -> "Unexpected"
      https://git.kernel.org/kvmarm/kvmarm/c/f3ec2787803e

--
Best,
Oliver
