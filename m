Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD7AE46AF0A;
	Mon, 14 Sep 2026 12:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789387451; cv=none; b=biw2Q+/dHFNaI/N+JjftlOD3SIEiEtg94/h7J9XvgVbsL7UZNs3FHDTHFK3kfkXnSZov6H2FEOFx5sL/hdmEkYOZqFthF8TlGh6f7VBw0XjVMj+s1yZykf0YCLjA7F3s6o6eas3BqbFS1wxuua3VqXBInn/gJDvN4Es1aRU41gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789387451; c=relaxed/simple;
	bh=RtTpxP8pV4hDCH5g+i9GKn9uX3fK5Dxgw5A97QNxBu4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NReY4+KNO7UlivrHcoc7dm7CKrBxCzwwSnDc/MunyORDHYpIiz0CLNHBv0qNBneXZ46sZ4jQ5If9rP6f8IDfaJBU7E2+hN2xabH0OLPhnC98V0MLGrQxH7RNXMQpqC2qJ8Vh4Wn0P7I+Jjxdx/vv7Yuc+1qr0ToL+VdxJHsB+fA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Mc2jwCH1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Mc2jwCH1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F79F1F000FF;
	Mon, 14 Sep 2026 12:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789387449;
	bh=mARYk2W4/W/SIK+a0P/KNzlHDuVLH3eh3p7dXfsuvk0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mc2jwCH1PvIMJoHyW8DTyVMyF1+L4f7PhXHUsU1X6mB1yEZAkZ2Pip9+nr+qnGS0H
	 RiJ5Avm/txkwAWCGGsYR3A+CPL7IZr9n1YXcDc2y9yLJQdLu5/So+SrSAbENyOvVoA
	 FyS+cY0DS5z9MQClh0Iqjwca67Rf+3BFNPeEsTCmywZRbl1zDisfQtmv6Mnae3Ez7T
	 SAgDj8wYZeX1KaK+B0TKbm5zeqEcoY3XSbqW7QY2jP4ERqtO0TNVQ/nU5Pmc/BKuSB
	 3O0nOoH8Ah8qKcCTptw3qH9KfsZD9BxvjI9o6L/EBn4M76JGTzJQ0DhsXqBoopIME0
	 0gkWU+0p7kGrQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1x65Pr-00000008bDg-3ZNt;
	Mon, 14 Sep 2026 12:04:07 +0000
From: Marc Zyngier <maz@kernel.org>
To: Oliver Upton <oupton@kernel.org>,
	Karl Mehltretter <kmehltretter@gmail.com>
Cc: kvmarm@lists.linux.dev,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	Jonathan Corbet <corbet@lwn.net>,
	linux-doc@vger.kernel.org,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH] Documentation: KVM: Fix the event_source sysfs path in the PMU attribute description
Date: Mon, 14 Sep 2026 13:04:07 +0100
Message-ID: <178938739482.3215146.12715753514288503521.b4-ty@b4>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260905085849.40479-1-kmehltretter@gmail.com>
References: <20260905085849.40479-1-kmehltretter@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: oupton@kernel.org, kmehltretter@gmail.com, kvmarm@lists.linux.dev, pbonzini@redhat.com, kvm@vger.kernel.org, corbet@lwn.net, linux-doc@vger.kernel.org, skhan@linuxfoundation.org, rdunlap@infradead.org, alexandru.elisei@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Sat, 05 Sep 2026 10:58:49 +0200, Karl Mehltretter wrote:
> The PMU device directories live under /sys/bus/event_source/devices,
> the document spells the bus even_source.
> 
> Fix the spelling.

Applied to next, thanks!

[1/1] Documentation: KVM: Fix the event_source sysfs path in the PMU attribute description
      commit: 1e3b8f0af9ae1de02d3bb42c6bb699af62510c10

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


