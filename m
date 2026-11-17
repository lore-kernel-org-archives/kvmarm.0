Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794952649;
	b=hW0rXtzLuGmTAKMMsHc2Y1dLFvuWuMl4Z/Qga4iSW39dQn2lC89WLy3twjF3dNrpi1E7
	 1kXpjgBmWMs2YOUCk2ukal8JSJGh9EvtvIjLmyrvS630LIM7AB1kfAVB0mahpvREht89r
	 9viweHkuONSsNrYgik+wRZywCDAeseCNxqWR9n2TduDGZrnJz/ER0ODCxRRREAaWWn7ia
	 vqit5ttJS76FFY6qTSPeLL3tCdDA6fDgjXwleuqUt1IKL8QKet1hAghmg1DAPXokC0i9p
	 ZUyrCgLhKHyEmlKiUr5YxoVO5dO84wqZG7GO4jB8wMr/6PW6hkG35D/EKWeCFI1Vgdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794952649;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=fm0JOqfmumXNaYfIcKsaZgcOXsOJwEEHVEF9rB5LLwc=;
	b=PLjvlKTbvlBVgF5zK0IQJ2mKBDy0W6eJDNbX7FYYO9b031MG76IM8GxFo++j857jZqVZ
	 gPj1u+LSTy4g4cyc4AIqrYQUjL3mA41D6DEKJSaGykdlyylzaNbOfnLzJcSRlIyF2PpBq
	 1LmrXeeFFX7fchuavmEyfcKQoNHYu8cxu02v03ejicXr67cZW7dcPlPyE3gLqUYHCM6Vu
	 V6O7C7WJlm8XdTZjQM5qtuWPxQKHSNQ1HThKUlms2AASfIHY+lzQcnQMwjvDzcq8L8D4q
	 BJ1+1FHhdVWVzSTtAIsAYQ0EkLohb5vBSjI9cu0eRKirSRBd4bmGqLUOKSmufg5XACg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=P21UoPiJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5C07606A32A;
	Tue, 17 Nov 2026 21:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=P21UoPiJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D4BF1F000C8;
	Tue, 17 Nov 2026 21:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794952649;
	bh=fm0JOqfmumXNaYfIcKsaZgcOXsOJwEEHVEF9rB5LLwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P21UoPiJcGdKOtXwqso+eLvWIqZkUziwRvE050c36SS317OVJyHDRl06NhHExC9r/
	 s+6GnSwBZoPPETzpIdlKj6pQWz3JVMw9bVhyfpE5q2lsbaPRJgPVigP+8ddTgZ4cAv
	 qUE/2j6NliS9MP8nSCn4pAO9UAMcnKzRRevzNZjPOPuQWvyGYWH7vvBtrkAJllJ0gY
	 tGRTX8x0gDqyYYKwQf7qKbZZZqU3kjus5dd3L1cN3MtOv2h2bttb1muY6us4cQZg1v
	 N0wxDPxgwwwO+3wXStJKfqTOFwXX4Ymawsl/8U9N63xMQNmMYTKDXHXHf6VOiEwfZC
	 6mgH4xARN7vkQ==
From: Oliver Upton <oupton@kernel.org>
To: Marc Zyngier <maz@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Michael Reeves <michael.reeves077@gmail.com>
Cc: Oliver Upton <oupton@kernel.org>,
	Myria Sarvay <myrialsarvay@gmail.com>,
	Yureka Lilian <yureka@cyberchaos.dev>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	Sven Peter <sven@kernel.org>,
	Janne Grunau <j@jannau.net>,
	Neal Gompa <neal@gompa.dev>,
	asahi@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] arm64: Add KVM support for newer Apple Silicon CPUs
Date: Tue, 17 Nov 2026 13:57:24 -0800
Message-ID: <179495264127.1456871.1866504028661732526.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261021-apple-m3-m4-kvm-v2-0-04905152cc2a@gmail.com>
References: <20261021-apple-m3-m4-kvm-v2-0-04905152cc2a@gmail.com>
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

On Wed, 21 Oct 2026 10:53:19 +1100, Michael Reeves wrote:
> This series enables KVM support on Apple Silicon M3 (base, Pro and Max),
> base M4, A18 Pro and M5 Pro CPUs.
> 
> The first patch adds the CPU part numbers and MIDR definitions.
> 
> The second patch adds these CPUs to the existing Apple Silicon PMU and
> broken SEIS workarounds. It also enables TDIR detection so KVM can trap
> guest DIR accesses without trapping all common registers.
> 
> [...]

Applied to next, thanks!

[1/2] arm64: Add CPU part numbers for newer Apple Silicon CPUs
      https://git.kernel.org/kvmarm/kvmarm/c/61615311ce39
[2/2] arm64: Apply existing Apple Silicon CPU workarounds to newer CPUs
      https://git.kernel.org/kvmarm/kvmarm/c/3a7b70524c54

--
Best,
Oliver
