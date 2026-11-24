Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.170
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795546936;
	b=H360a2NqgWLTWe/HQAOvahiy9wVGSAeRIktG9+eMvbS28Op84ubbXU8A7e0M/GkBK5Rx
	 LINTKblKcbqXjH5IfyyG/OFFKY0ljp+3UyPaDQh4QZw5c40vzTDCceoTJ3K4AVwdzLX4S
	 h2numOFIVQ+UGPWsvM7+HhKRSurD/h7Rq66X2E4DujqTPHFUwHc0A+xRqXklMZAhvIWcv
	 piWdXRYFdoCNYFbi4tkMrOB3RAd7YDvQc/+hB1rM7WWA9+aLjsFLHaY6sFx+nVs0ZbIXY
	 B2n7ScxpQk/GsCpft4m0RO+2ssK89GFerwFp0YQbl9GiQeYj0Jn+yEka3yYMjZUQRgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795546936;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Mime-Version:Content-Transfer-Encoding:Content-Type:Date:Message-Id:
	 Cc:Subject:From:To:X-Mailer:References:In-Reply-To;
	bh=vmPlBJsxyoTZOO9g2mmGNuUfH7b/frSSah/ZWuzVmhc=;
	b=0pEKmq1SQjpnlWOSCeovmwMId3WMMGodPoiKGAomxPPD8llBMSFvyHdsOmDU+0w5XfoG
	 ZNW+1xezVFxOc7RNYR90tgth2sMottk9Yk3sTjgOp6PYDaD8cipD7fd7qT+lODY+UT9Mh
	 OcQYgZRwIc4a80A+jiwWk+LsHJ2WaqVelyYeqwHmZAEsM8Rrmty8/GnGlpH7Cl6JqGNNH
	 /4c42p3+EjrsVUl0ovxXPAuDvSZ7kdTBtkxjVarXIcjiQgC7XCPd9s/9MxZYcbbzmxW4K
	 oiYP5VIevnbsuK7gIKHWmxvI5WrbncPhPN3GJUk7y7ENu7pj3hECTF85rIj4Qh851iw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=KN56XpNr;
	arc=none smtp.remote-ip=209.85.210.170
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCBEE606A321
	for <kvmarm@lists.linux.dev>; Tue, 24 Nov 2026 19:02:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BCBEE606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=KN56XpNr
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-8b66d1a08ccso3432861b3a.1
        for <kvmarm@lists.linux.dev>; Tue, 24 Nov 2026 11:02:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795546935; x=1796151735; darn=lists.linux.dev;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=vmPlBJsxyoTZOO9g2mmGNuUfH7b/frSSah/ZWuzVmhc=;
        b=KN56XpNrGj51CXjSAY7lzcawJYoA2NWATZKstRc6ZCl0CmJQnvcIdP4EsWw/ffhhUb
         KwPaigyyPAcNEPmpCIRWR40tte3ebqA/XjVFozYdwu5XJWx/TANGHXUg80Py24XBb1Xm
         1FFyUx4eVgouSSfONFBuxKZVomuOEoltFDcYS+q48Ywfif6rRP28uHXfI5oCap2I0jEf
         fpupODx0DQuUyuBj60rx3PW3A7buGVJs1ZyPSFBHcc3n4M0eO1txfNPEh67P5G7wd97z
         Re3vKcYPjngYnFolCBfA04eRw7rxoef18o/UtA/uFeWcZpe6+CmruVq2TtkDE2N2hc2T
         Q+ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795546935; x=1796151735;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vmPlBJsxyoTZOO9g2mmGNuUfH7b/frSSah/ZWuzVmhc=;
        b=fJ+XdzKyhWpw13sC43YZbKL1inQ04fSANsyPoGyQQSf3nszehhGOXWGyBMRg94oIGR
         6a/aC3UZeNKLpA4MI5/lznfXTwrv9B+THBKLfeVI6je/j1NqLzxjLWwrPUXu4nClIVD8
         1hRPRSEZHdUvoVJJgtdKGspkFePFDkxZAgjQ1NjPHr/ocm+sa0WNnNqUawyfcdGd9PkQ
         ntCxdSsuvspz3C1kCfWFLghIfC3kHoZj6Gd3ocsTdh/PhJY+qitRlbnKGs4oVvzG+EsB
         u6yu/waCC+jSTkc6DQoMe1Sibv7aeL2OEQ9Iq12Qfoqv/XUAsQ+ZRWffzxK+45sEzi/z
         AVUg==
X-Forwarded-Encrypted: i=1; AL+hErEnr7H9kuijf/DivcsVtFYxCi6iuAgYjbp5B5UoUBawz+LbPmV1UJsVeuiL7yHweji+VewlX4w=@lists.linux.dev
X-Gm-Message-State: APuU4Z9pq/EmsQNIFyMpz02sbHPErzI4q9E/FUkxTJyAiN75JRho2Av9
	uMxyOOymz5+FfurcnuHLJAk3XJ0eYrBQ5BF+mVAXGOpD4iioMg+vM+loPS37VdROyQ==
X-Gm-Gg: AZFdTZc7YPrGCbFDB2Z7LrqqHboU12Z3Zh4G4sR0wklZ4pVtguEoMlB2Em+OXUOd4kz
	4hqPrKQ8IDe26ueossxL9uyDVpvV5RgvyzGH4Evqcras+Q37aJxl3HU/Br+nRVtFcVGIi3kgHns
	cmY0vTr06aSs1MS35pngCSohIMNHTiqI6jbkITSAeRDPaxhjFvom4XK9ozYaS6zXoWyGIEhwdPp
	v58PgVWQqlD3xYgMo6XOOuZhQ1LqDv2YvlfpH6YZZ2FhsUFgIBgfNTlubZW+Iy62152CDJWKQtL
	JT35Wm95oCCC8SDaRRgi4SS6g6BiEQp/rjrUnU9RcXhevXIvwzKkqoDdXq+QA/0TOhRKmy5CJ9r
	96zjvP33Gc0FkKLd8HUsJbs2ea4tZ7OJs9kdXFraNGHNRRaU+KZUMlTG9z7s60PFelo4e2O5252
	tzjXqxZJxdb4nepyElVtoag50ZUw5aNuI87NG6IVc7cPM7PfbEsWasQMP10QV9qtzNl3NFaz7jg
	yVsfixMLJEC5glCNrjWkTstJ6rjXd5FlPXRQW9UXjGuIlAxVe7ufcPAVt923cACmhxt+RfcYMGl
	emBfclGduud0XP4yxk5gkc9KFl3OoIU+vBW2D4NszW6Huo1sOodECzo5AWrbemv4DA==
X-Received: by 2002:a05:6a20:a11f:b0:3e9:f2d:d556 with SMTP id adf61e73a8af0-4014ca44d17mr16159174637.55.1795546934090;
        Tue, 24 Nov 2026 11:02:14 -0800 (PST)
Received: from localhost (33.79.127.34.bc.googleusercontent.com. [34.127.79.33])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cde9bb05981sm2247135a12.26.2026.11.24.11.02.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Nov 2026 11:02:13 -0800 (PST)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 24 Nov 2026 11:02:12 -0800
Message-Id: <DN3O9LHR4XNH.1EYLA6D1F0J2P@google.com>
Cc: "Tarun Sahu" <tarunsahu@google.com>, "Pasha Tatashin"
 <pasha.tatashin@soleen.com>, "Mike Rapoport" <rppt@kernel.org>,
 <robin.murphy@arm.com>, <maz@kernel.org>, <will@kernel.org>, "Alexander
 Graf" <graf@amazon.com>, <seanjc@google.com>, <jgg@nvidia.com>,
 <loganodell@google.com>, <arnd@arndb.de>, <dwmw2@infradead.org>,
 <baolu.lu@linux.intel.com>, "Bjorn Helgaas" <bhelgaas@google.com>,
 <oupton@kernel.org>, <alex@shazbot.org>, <gle.com@google.com>,
 <pbonzini@redhat.com>, "Andrew Morton" <akpm@linux-foundation.org>,
 <kevin.tian@intel.com>, <joro@8bytes.org>, <kvmarm@lists.linux.dev>,
 <linux-pci@vger.kernel.org>, <kexec@lists.infradead.org>,
 <kvm@vger.kernel.org>, <iommu@lists.linux.dev>,
 <linux-arm-kernel@lists.infradead.org>, <skhawaja@google.com>,
 <sagis@google.com>, <linux-arch@vger.kernel.org>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 05/19] kho: Add feature header for fine-grained ABI
 compatibility
From: "David Matlack" <dmatlack@google.com>
To: "Pratyush Yadav" <pratyush@kernel.org>, "David Matlack"
 <dmatlack@google.com>
X-Mailer: aerc 0.21.0
References: <20261110050202.529473-1-tarunsahu@google.com>
 <20261110050202.529473-6-tarunsahu@google.com>
 <2vxzse0rzjdn.fsf@kernel.org> <DN2RQ7LGX224.3W3PSQ2PBHTJZ@google.com>
 <2vxz33sqz1xj.fsf@kernel.org>
In-Reply-To: <2vxz33sqz1xj.fsf@kernel.org>

On Tue Nov 24, 2026 at 7:25 AM PST, Pratyush Yadav wrote:
> I don't think it buys us any functionality. It just hides the problem in
> some lucky cases.

Following up on our offline discussion: I think it's worth keeping
support for optional features, both before and after the spec changes
land.

Before the spec lands, optional features are the only way to enable new
features at all. For example, the PCI follow-up series [1] preserves
BARs and bridge windows using an optional flag. It's purely additive: a
kernel that doesn't understand it keeps behaving the way it does today.
With optional features it can be enabled as soon as it lands, and Live
Update keeps working in both directions, including rollback. If every
feature is required, there is no way to enable it until the outgoing
kernel can learn what its target supports.

After the spec lands, optional features are still useful, and at worst
harmless:

 - Kernels that predate the spec mechanism can't provide a spec. As long
   as one of them is a possible target (e.g. for rollback), optional
   features are still the only features the outgoing kernel can use.

 - The outgoing kernel doesn't need to consult the spec for optional
   features at all (less complexity), since by definition the target can
   ignore them. It can always produce the same payload, and only
   required features need to be gated on what the target supports.

 - Nothing prevents an outgoing kernel that has a spec from choosing not
   to set optional bits its target doesn't understand, if we ever want
   that.

The cost of keeping them is negligible in the current design: the same
number of bits in the header, and one range check on the incoming side.

The one rule we need is that optional really means safe to ignore, e.g.
optional data must not reference preserved memory or carry restrictions
that the next kernel has to act on. Anything like that must be a
required feature.

[1] https://lore.kernel.org/linux-pci/20261019213054.3157159-5-dmatlack@goo=
gle.com/

