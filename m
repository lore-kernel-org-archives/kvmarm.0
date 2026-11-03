Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793711179;
	b=XBPMPNQ0hOl6ZEvM2mTI8vqXCj0QQfNgQScesI6NGFax5Rqya+46QP0zpkEvfyxIOJJs
	 xU29PIvluEba8O11PZtNf8HIvaOFdHsbAhnJlmNYulL0EZ3YbFxfDNxFXm69DSA74gzxH
	 ByEbDQ5IU0qtz2zziSKTzWPgY4Rsiw6CV6uomihDtgjdXANvUCjZ/EJO73nKZrU/m26Op
	 GuKmYb241Vish73OhPJB471cDdHVXa0lU+0MDL137jo8j7OsGwf9QXB8045901ORLX4mt
	 jXZLIA2v3/3Tq/Vq0UXUnowwPEpoHkVWSoHK5ruVZxGdRJUG6LMgkNNvatppsrdjzPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793711179;
	h=Received:DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-SA-Exim-Connect-IP:X-SA-Exim-Rcpt-To:
	 X-SA-Exim-Mail-From:X-SA-Exim-Scanned;
	bh=tWxPJzZwEoBsVUWyHIoViN5NlrycE+BNkSoICL6D6cY=;
	b=4TtNTmDm3CdbCgliB8v3qJpOLQy0fDku4m1jmYd2ADd3DX2Cj0qT8Gg6lNe97ZlWbUhU
	 zrksXdtuXah0P3U59N0U7mBCVM4seak/tiZNN4oCTEv8MKu3EEsrKP9714TwRdi9Qpzuy
	 8EyV2+8ksioYDFd7CjOiX/bL1oU+gXbAITRwlfkmq17Wxotk/ZCirO3PxdoFmMQxWyAOb
	 b+wLbQXxhuZXvzoMuL3ZqIMkUjJn8cEqpQ3zGxFqm3SLcLJWQqrQ5OE2xOoTI2uOjuDPY
	 jhDdHqf5XT1vyxsv1gGde/HDGkMM+ZWtC2usuZ61ZeFqyZZKXfkOHWDnvZsJ7V40H9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=G1IFRfsM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D17D606A327;
	Tue,  3 Nov 2026 13:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=G1IFRfsM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 298B21F00A02;
	Tue,  3 Nov 2026 13:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793711179;
	bh=tWxPJzZwEoBsVUWyHIoViN5NlrycE+BNkSoICL6D6cY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G1IFRfsMsfNhwvUPIp3LCRqhl4kH/da+XzUX45vDSJ0J0prTPqYKv2B2oSD9Tc5aN
	 o9B0atx6oVZLwSdoEl65Ec6NdGRB3Vg1j5Q8MvieJR2BIY3NQ0KSlwizrEX5ClSVdz
	 bjZJqTLNIVAJuhKlVW+70aQZBXK8cmeVnj6FG9H8KsOIyYX+k33fSbyG5asVexm+K+
	 WFE+gjZmXeMHygR2ULEOapK3S3ZT/eDFG0hgKhE7Y0tuSANS5/1WJOC75eebzHBUbY
	 bbRyfpW0PAQ6mJ59O5iMKwGYeQ8TI2eliUM9OCayKHUiiyk9elWlUVZ9CcpBvK+3IN
	 pzjtyoPZOlKjQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1xOEDQ-0000000ATWs-3vOV;
	Tue, 03 Nov 2026 13:06:17 +0000
From: Marc Zyngier <maz@kernel.org>
To: Thomas Gleixner <tglx@kernel.org>,
	Colton Lewis <coltonlewis@google.com>
Cc: Radu Rendec <radu@rendec.net>,
	Oliver Upton <oupton@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Raghavendra Rao Ananta <rananta@google.com>
Subject: Re: [PATCH v2] irqchip/gic-v4: Use a separate lockdep class for vPE doorbell IRQs
Date: Tue,  3 Nov 2026 13:05:28 +0000
Message-ID: <179371111254.2844725.1319552424303810824.b4-ty@b4>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261027180610.2840837-1-coltonlewis@google.com>
References: <20261027180610.2840837-1-coltonlewis@google.com>
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
X-SA-Exim-Rcpt-To: tglx@kernel.org, coltonlewis@google.com, radu@rendec.net, oupton@kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, rananta@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Tue, 27 Oct 2026 18:06:09 +0000, Colton Lewis wrote:
> By default, init_desc() assigns the shared irq_desc_lock_class lockdep
> key to desc->lock for every struct irq_desc. Device drivers that
> register an IRQ affinity notifier establish a lock dependency chain of
> &irq_desc_lock_class --> &pool->lock --> &p->pi_lock --> &rq->__lock
> when irq_set_affinity_locked() calls schedule_work() while holding
> desc->lock.
> 
> [...]

Applied to fixes, thanks!

[1/1] irqchip/gic-v4: Use a separate lockdep class for vPE doorbell IRQs
      commit: 7100185bdc1162eb2eca1dd20a036314e27f1561

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


