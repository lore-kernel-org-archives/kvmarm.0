Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88B483491CD;
	Sat,  7 Mar 2026 21:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772920150; cv=none; b=IsNvMrQhej8S1yk4hRS8pbteHZdtnf/v8neU/++ZadbkAzWYJQJLcg2dY1jdANummQ4wArsizy4ktp766t0FXE00hh7HBqUDEvPBK06pTuu4onS5DA6d61xZYKQHzK/IKz0YmCUW1Ufi4YqOQ1YafDh143QFsLI31oBM+eGMHSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772920150; c=relaxed/simple;
	bh=JWLxBlGMmNnVczOuCHRUgXf0FzVigXkQFSML94D6Cx0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KSN4XU4Gn+doA5eeSggIMxYUSy/TkLYatSCC5j0qk3cZS41bJyo/tIUVQ25WfWHvss2HSEFl30JLeZcFr45G9o8jmqwVQ0Frj5qxHRhhmKisusiCKxFt1MbELso4TT9torgve8c3yOQCFcYVxWgNJyvjCOkRsLF+axWXRlGOP1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fQCA5/Ml; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fQCA5/Ml"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16919C19422;
	Sat,  7 Mar 2026 21:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772920150;
	bh=JWLxBlGMmNnVczOuCHRUgXf0FzVigXkQFSML94D6Cx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fQCA5/MlBKXDR4oXT1l9H/9pTCP8+w2vPahmkWTT1tPbTrstPQnMQEQvlGG0dp13w
	 UeFQ7/Bk0n1Gi9YpGSkBsKKwEU8KJh8z+yo1tnxm6xwAPZ7hHoxmrVrRdKKf9Vk718
	 HzBWarD2cwC2F0as3IUOiRQtnxEMvkXtmTX2x+JrhNQB0SBDRJ4ep7einjzlyn/xN0
	 iLm0ye2Hy7JmIWp+BElVNKJzXUkQ/dbW6XCiI9Q6aNgtjtrxJEARCFPXuL8dOrWf4q
	 x5KvsAsYL9QM1Te8c2oEdL+TuIIamrE8558JayF2RRYzsCUl0ca1zlmHD16Ihnfq8Y
	 cemFG3saEpgRw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vyzWF-0000000HExA-36SL;
	Sat, 07 Mar 2026 21:49:07 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Valentine Burley <valentine.burley@collabora.com>,
	stable@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: vgic: Pick EOIcount deactivations from AP-list tail
Date: Sat,  7 Mar 2026 21:49:02 +0000
Message-ID: <177292012643.3782537.4761110161677625245.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260307191151.3781182-1-maz@kernel.org>
References: <20260307191151.3781182-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, maz@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, valentine.burley@collabora.com, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Sat, 07 Mar 2026 19:11:51 +0000, Marc Zyngier wrote:
> Valentine reports that their guests fail to boot correctly, losing
> interrupts, and indicates that the wrong interrupt gets deactivated.
> 
> What happens here is that if the maintenance interrupt is slow enough
> to kick us out of the guest, extra interrupts can be activated from
> the LRs. We then exit and proceed to handle EOIcount deactivations,
> picking active interrupts from the AP list. But we start from the
> top of the list, potentially deactivating interrupts that were in
> the LRs, while EOIcount only denotes deactivation of interrupts that
> are not present in an LR.
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: arm64: vgic: Pick EOIcount deactivations from AP-list tail
      commit: 6da5e537f5afe091658e846da1949d7e557d2ade

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


