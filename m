Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793016080;
	b=DU9p7b4td4bbdyNt7o546FM9g6gDlEQuQinxKDlwYo/sHTWH0bRyIP1uvOU+94CDP3L8
	 q1ox5/tflPOEKefMF8yydaWPqSLMAnItJjhxlqPTffBAi+4zYzvJt7VOsCxiAI+g6GfO2
	 zzdmjVlddBRmmUmo/0UIJjfQCGStHQnBgmZzCSlz57ZyIexpe4YrEIoavlExhrYwe2JLC
	 TMVhX4ceuCOLwRUSI24MWW0DJruBtdQUkpXXYItb5YHpRuKd01KDcPIbIt9pBoZve/5FZ
	 f08OHKvfp+pLR4Wdn4D2Rr73mP7uT1PY3prX4rtFIqIC2jcC0+eeyftSurvtYBgn9BA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793016080;
	h=Received:DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-SA-Exim-Connect-IP:X-SA-Exim-Rcpt-To:
	 X-SA-Exim-Mail-From:X-SA-Exim-Scanned;
	bh=7jqk4Wusj+dbOg4A9kCrSGLO68/43vHoF4FXQEeCH0I=;
	b=klQahzyF2l3q0qiZ5IxZ5zisbDgYhtE5mC0vFiugFFvvjpDX2QHsdrnFienD9HqRixv8
	 GDfZh74qTp+pFo/PBMD/aKEIDMwttAhYHVuncWyLkowFxNQL8m82FOM0DdNts1Np/lDRi
	 7AuCi+JQXK2wIs7M2+BAUOBW7k5R5nk47RBUGGaxbWu7pJAcAQYIJwC+xAbuYnovZZsdv
	 BhNxb3i2HsqMbVl1mvlepAJ+WgedjjmfW/ra9VUlwg8zfGJU2un+GXV81xg68a2mp0dFy
	 lb5kK0xP6fIVgsupCUeFa3Q117JbCaOZzHhbupAPSeSuTVkSPrG3QTKpGuonZGcVvhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mqGZjti3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AADC60A2605;
	Mon, 26 Oct 2026 12:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mqGZjti3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AEE41F01829;
	Mon, 26 Oct 2026 12:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793016080;
	bh=7jqk4Wusj+dbOg4A9kCrSGLO68/43vHoF4FXQEeCH0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mqGZjti3x9eLYOQqnwLx/WRv/5LOs1rrJEUDXgx7hgVZALUeDD7mDdINyRXzVIbuQ
	 L7SUTZbMX3eIbEx4jyur3RTA88/7qUIA6InFOJde3klYWVuO3H87+719wLth4Mam7d
	 xF4pLNndTo43/byerXjx2eNuyxPh8CRZnACt3aHX0Oh20FX9Jn7ZzFUoJfTuvaGE89
	 fbqDZYA110QxtNNdvYVXKbOAaHBCSenMna1ZM6DMuMiz/4pQ91sReKbRuTKp10d6si
	 /aR3Gukxe0R1K2oVFjKHBMi1rfdFavUoc7SJy96nNhIKnMl7IW1cwKYIG/tP79B3iI
	 VOcvUC3/smlWg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1xLJOA-00000007Fr6-1mpF;
	Mon, 26 Oct 2026 12:01:18 +0000
From: Marc Zyngier <maz@kernel.org>
To: Oliver Upton <oupton@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Cc: Fuad Tabba <fuad.tabba@linux.dev>,
	Mark Brown <broonie@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Itaru Kitayama <itaru.kitayama@fujitsu.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] KVM: arm64: selftests: Skip unwritable ID fields in the failed-run test
Date: Mon, 26 Oct 2026 12:01:08 +0000
Message-ID: <179301587204.2527370.7441548835620478409.b4-ty@b4>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261026012128.2270251-1-sashal@kernel.org>
References: <20261026012128.2270251-1-sashal@kernel.org>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: oupton@kernel.org, sashal@kernel.org, fuad.tabba@linux.dev, broonie@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, seiden@linux.ibm.com, pbonzini@redhat.com, seanjc@google.com, shuah@kernel.org, ljs@kernel.org, itaru.kitayama@fujitsu.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Sun, 25 Oct 2026 21:21:28 -0400, Sasha Levin wrote:
> test_idreg_frozen_after_failed_run() checks that changing a feature ID
> register after a failed first KVM_RUN is rejected with -EBUSY, and does
> so for every field of every register in test_regs.
> 
> On a host without AArch32 support at EL0, KVM treats the AArch32 ID
> registers as RAZ/WI: aa32_id_visibility() returns REG_RAZ | REG_USER_WI,
> and kvm_sys_reg_set_user() ignores the write and returns 0 before
> set_id_reg() checks whether the ID registers are final. The test then
> fails on the first such register:
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: arm64: selftests: Skip unwritable ID fields in the failed-run test
      commit: a4be8d69698b11d976c122be2d32bb72b8a52809

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


