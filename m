Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E0AA3DDDAE;
	Thu, 12 Mar 2026 15:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773330299; cv=none; b=REpjqroDPt/pN3UiX0+/0Z8xKzy4LHTb9/d7GgAtuSqT234ldVFO5AdlTVPKUv2jK6h3hZAVWdcNU/CQp8cAr1jgQZEPxdE5MtjbUwggkA+nE3Gdls3UJnymhhYp3tRx0ob2fQZ2rOawRQ0CVF3ARidMyiKvlczkebrIghq0UtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773330299; c=relaxed/simple;
	bh=dim5vS/0UxX5V8pSOK5wUgvRIRBEQUy/yOLGKKhjj+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tRONt5j1U5FnjDIc9ZsrI5IVsM4obCEQ0Iba2d/0gLNe6h1bxYoqCyU0o/DqBJGnxmB0MXrH3YSwbTVSPDrcBvVD8ABpOT5f2MGNti90LspDoEIXo25/4hwvlL8A6f4PGyi7be+iAXeci8DmvCvySyyzbHD6vwqIUwQPPQ6Q0IA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GIMpweYY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GIMpweYY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2B4DC4CEF7;
	Thu, 12 Mar 2026 15:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773330298;
	bh=dim5vS/0UxX5V8pSOK5wUgvRIRBEQUy/yOLGKKhjj+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GIMpweYY6twiRclbLF19Dc9NJszMq91UHkFS39bqNz66pi/anEhL5JMjld1nG9sdm
	 Unz1r/oNymiHghfz0JIkar6QHgQUdVHN5Oyotl11MhvShdLTbcEHcw28zt5L22VbQj
	 KR4k3pCm8Vb+xjuu3W25Nbh1heSgWMQWRI58LHPmgS9N4P35YT1JG6NDCoIdxwSiH4
	 jBbDVF8Jnlceo8WU5E0LcnIsgfEwY1MpxRPn09oYTxmtIW2Pul2ZreJXq9dz/1fB6F
	 ekthyKkv6n8PFZyXhTpExPX9tOhXmUbRhbKL18Szc+tjmHgd8/70FTgK9CukLkJK6K
	 08N8K1bBMNsyA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1w0iDY-00000001KU1-1THK;
	Thu, 12 Mar 2026 15:44:56 +0000
From: Marc Zyngier <maz@kernel.org>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: rostedt@goodmis.org,
	linux-trace-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev,
	kernel-team@android.com,
	Nathan Chancellor <nathan@kernel.org>
Subject: Re: [PATCH] tracing: Update undefined symbols allow list for simple_ring_buffer
Date: Thu, 12 Mar 2026 15:44:50 +0000
Message-ID: <177333027966.824271.12312188181970729124.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260312113535.2213350-1-vdonnefort@google.com>
References: <20260312113535.2213350-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: vdonnefort@google.com, rostedt@goodmis.org, linux-trace-kernel@vger.kernel.org, kvmarm@lists.linux.dev, kernel-team@android.com, nathan@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Thu, 12 Mar 2026 11:35:35 +0000, Vincent Donnefort wrote:
> Undefined symbols are not allowed for simple_ring_buffer.c. But some
> compiler emitted symbols are missing in the allowlist. Update it.
> 
> 

Applied to next, thanks!

[1/1] tracing: Update undefined symbols allow list for simple_ring_buffer
      commit: 5f2f83047126f1cb2986d142d2e76e1fa3cef3f0

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


