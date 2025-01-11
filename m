Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7DFA32C8B;
	Sat, 11 Jan 2025 15:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736607751; cv=none; b=ZKIzdRCYcKxHi93NMMIYeIi3IA7nUlWa6APHDh2XpKB2zdvnbc0U53LZgfl98XrmV52Bdwk6IcgdVPxBj7dft/RigW/p0GjTzaoCalz6ben65xZSVE1u+ztChH/v9Lx4yfiAWkfe+g3k4mfKbmxnruoVRMGk5cLraiX54DtKvLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736607751; c=relaxed/simple;
	bh=7lwQfD6yq/o36zvjpn1IVBMjoiNqqFbRoqIKQisG5CE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jNX1F1Yz8oGFxkQC3kU4BUimLqYTXdAkmZkzKzaCkjdnaP8XOg8PqKsWf7QaO6+Z0noZXbF9AngnuIQXXwwYy6rzEK4eyb3tTkMHmSzZ6k0iRhhwo7tbIt8E9zzrsd/f/1l/wAaodzPeFA73kKEYcgmn6+sQ915yyCZwqivTZEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FlCUxOW5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FlCUxOW5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BC61C4CED2;
	Sat, 11 Jan 2025 15:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736607750;
	bh=7lwQfD6yq/o36zvjpn1IVBMjoiNqqFbRoqIKQisG5CE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FlCUxOW5iwaxmJzmOHL//fCfotRXp1y6qS72ZkHgufM1LwU6zJHYZU0d6dUJeJYh7
	 LNAewkX6CBBlWGQe2t6c6SUvhCDSEaMLQztGpi2tnq21/TSqQEB7uxtLMMPwQ5qBp+
	 kGBdWWVBxzY/5+NPfA0kKh9kH43CA4VlpaZ+wr/DmDaK604yVU6SZTF0t2G1HXmrUE
	 lKdxy6u1kQ4qa9WT8xaaPnWlUMAizMaSDNa37sRRCUPDz0PdyQHDQta635sROZp0X7
	 dTnr8PwKYMHMm5MrNwsrYdmvdiQ6nua/XNnjDDny3bKiu95o+qHbqKg4EdLae1LL1T
	 KBoC062f8EkWw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tWd0O-00BBeR-71;
	Sat, 11 Jan 2025 15:02:28 +0000
From: Marc Zyngier <maz@kernel.org>
To: Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Sebastian Ott <sebott@redhat.com>,
	Fuad Tabba <tabba@google.com>,
	Thorsten Blum <thorsten.blum@linux.dev>
Cc: Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: vgic: Use str_enabled_disabled() in vgic_v3_probe()
Date: Sat, 11 Jan 2025 15:02:24 +0000
Message-Id: <173660773860.818546.5098329135149930806.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250110225310.369980-2-thorsten.blum@linux.dev>
References: <20250110225310.369980-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, sebott@redhat.com, tabba@google.com, thorsten.blum@linux.dev, christophe.jaillet@wanadoo.fr, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Fri, 10 Jan 2025 23:53:09 +0100, Thorsten Blum wrote:
> Remove hard-coded strings by using the str_enabled_disabled() helper
> function.
> 
> 

Applied to next, thanks!

[1/1] KVM: arm64: vgic: Use str_enabled_disabled() in vgic_v3_probe()
      commit: dea8838128c580cc6b563c901576b580f93a703e

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


