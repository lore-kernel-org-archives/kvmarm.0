Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2F5821859A;
	Mon, 15 Sep 2025 10:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757933361; cv=none; b=MtHgLTaleysPkdR3ba4rOL/wcLGFCiNWVnUqrLP0AGtCo3A9Ox3cEQkxItnQAcajjVVfuEgdoQTEFqrjIz8BgnquQ3LfabeG2Q/gyaKFn8YxkLY3pQf7AbUYcTmAQuR7rmtf9/YjqVRHXGxBlZXyNyp6qa2QRk2DkvABs26nEK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757933361; c=relaxed/simple;
	bh=4DiSgYMz8F2wXzrctnA9iRgoWb2okBFC865kP4Gxo9c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IABN+VIYUGmPZM3cyA3bhSTFtt/0WIGkinBXoftIEf2sGv2koCOdf0kJAbCkME8uMCBtoDdJQ4D7h7Fuk60S0EF8KRQYaqMb2fhOxtSqhfv0ScAc1nVp3AntLS+SOh/SBrYq/PhC/tJIBXjZkkPnvdhoTNcXimCCB5Z3sQRs97w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UuYfNQK3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UuYfNQK3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C20CC4CEF1;
	Mon, 15 Sep 2025 10:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757933360;
	bh=4DiSgYMz8F2wXzrctnA9iRgoWb2okBFC865kP4Gxo9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UuYfNQK3/UM57VVpdB5oO0wZ4ZQeiVA/kSREV0ovvWmwrDrco4gN/VjyHeq2qhkCq
	 k8xV+E5MMzND4/h98kbspRJUR49XJH9q0bAK5C7ky8ZO2kGSUA8WXkmI7klFqpKa7i
	 VnM8FD8lpMn7oJPvFhSXb4iofemu21mizrNJ6cWZ4hH2F/Rxp9ti68uYNNXTjXSEcO
	 qtaboKSLJoxKorC7cfMcBs67G8UDC6qQGusiSiwFqO6wRtwaGcdHy5FTVIAhNNGXXA
	 h20je+sVSpN/t5EbVn/qAig0kfJm/ZGSyzMUF+PDAtdOXt7W+CqmfoSHKoE5x+QYOk
	 kkIxEqZjoZE4w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1uy6lo-00000006Kwj-49Uw;
	Mon, 15 Sep 2025 10:49:17 +0000
From: Marc Zyngier <maz@kernel.org>
To: Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	James Clark <james.clark@linaro.org>,
	Yingchao Deng <yingchao.deng@oss.qualcomm.com>
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	quic_yingdeng@quicinc.com,
	jinlong.mao@oss.qualcomm.com,
	tingwei.zhang@oss.qualcomm.com
Subject: Re: [PATCH v2] KVM: arm64: Fix NULL pointer access issue
Date: Mon, 15 Sep 2025 11:49:14 +0100
Message-Id: <175793328164.659173.8404797812390171241.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250902-etm_crash-v2-1-aa9713a7306b@oss.qualcomm.com>
References: <20250902-etm_crash-v2-1-aa9713a7306b@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, james.clark@linaro.org, yingchao.deng@oss.qualcomm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, quic_yingdeng@quicinc.com, jinlong.mao@oss.qualcomm.com, tingwei.zhang@oss.qualcomm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Tue, 02 Sep 2025 11:48:25 +0800, Yingchao Deng wrote:
> When linux is booted in EL1, macro "host_data_ptr()" is a wrapper that
> resolves to "&per_cpu_ptr_nvhe_sym(kvm_host_data, cpu)",
> is_hyp_mode_available() return false during kvm_arm_init, the per-CPU base
> pointer __kvm_nvhe_kvm_arm_hyp_percpu_base[cpu] remains uninitialized.
> Consequently, any access via per_cpu_ptr_nvhe_sym(kvm_host_data, cpu)
> will result in a NULL pointer.
> 
> [...]

Applied to next, thanks!

[1/1] KVM: arm64: Fix NULL pointer access issue
      commit 27d2b47eef033f1fc6c0452dc1017e43dad5fe14

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


