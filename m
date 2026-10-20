Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792540403;
	b=FEagwnet+xSuNfKi6ytVlZMG3Z5VZwFc9D4aQu6iuBGGQD2SMONnVgK0r+mVuJcl9SUY
	 /n0HngnyO0gGosNU/80LiKPo5IZ3h4IMyVCYRJXnkBbXhDbsFSGDa+Wu4C5LZGlk+3fw7
	 dEwQvCF8lthKKK6FURb4JtD0myrLojmnfDnJZun69iT2j3VnMNulCJakhgCdKEy4eJWPP
	 lIMpQRv9CewQRkqA6vrIn7IvVAlYHFivp4a5rYNChqB+yLDGMGiXg+l4/C5u1FpLUt5l1
	 TTZf4aP8fNqLRl+JCWAa6Z4mBpcsYRVTOJzE5gU+aFTB35p/AoM/mzDeE/QFy7kiXeg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792540403;
	h=Received:DKIM-Signature:Received:From:Subject:Date:Message-Id:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-B4-Tracking:
	 X-Change-ID:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-Endpoint-Received:X-Original-From:Reply-To;
	bh=Kel4RSYESjXcs8Dg40JwYXjmWcDIJY09nOoIQY6d2LQ=;
	b=4PE3JicsOI75dxb+0ssw8QiyXq4VDBSWgsm6lGKHp2bnH74qb2nHFqW9nSfvlFAx0rw3
	 4Sz7kvcLpflDIECPsxFq4icPiN59DKbVmOzkcg1uy0yF3/k3WAakIsvcmTX7TV+DVxSIM
	 aXb0QitmXAt8WzP6lmsI+AolagOKGMdX5S9ptjgjfic81IpBOqYfpRvyagdvzCzkm0MRz
	 npkaqNQruwa9aTjNO+HRtEgf6/YjeHl1CunEyj5qAPBgdZ7n2u7ZZtEuweEAThV1H3Bpl
	 j7A+MHkGzLV+pgTzQL4OXVyMVqMIUeCTbqtBeQxnLmCDMv5TXAtib/BD8Hye7n5NlDg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NL00w4KL;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A518606A31E;
	Tue, 20 Oct 2026 23:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NL00w4KL
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792540403;
	b=YrbyLersiFbL+bsZNjvQXg/p3/jq0iYO8cn5Xql/g84tRs91sGvTNKJYsEU3jZX2mMn/
	 WqFLzI2VMVAgHE/pnFI/1yNrs7bXvSbJBvYor3pvxVnb7sMwINytwQEsRxK0moUCsqg7X
	 enXWbnsXQ1hPdyhikXf29fIbBP9Jp68RD4etcYt6636ggbozafKe82Sc96jr2DttCC8aW
	 aJSbplXdpVHh26D7aXqALQ60qh6sxCPcxdQ9OgzA1Xu3sPqZufpgeUlvuhYgiWNXvPCuX
	 tiTGNjCuOOAunCN7Mbp7a+3TSa/l3eIwRkftcqvsYilAVyu9QFdThZJbQacdoqFzQjw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792540403;
	h=DKIM-Signature:Received:From:Subject:Date:Message-Id:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:
	 Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=Kel4RSYESjXcs8Dg40JwYXjmWcDIJY09nOoIQY6d2LQ=;
	b=Yv2mv6uX3fyY2grTI0SlymEzU2bvzI/KXD9Abf0zyeZEdvGtXYyhqlyNmuGkQ/4MZKOL
	 h+Hy0DEHZHOCVwJ08mrgsgCxRw3xcUquqVuNiMAal7p7Pr6ipvQ8jW6bdiIJurseS1v/n
	 KtKh4fE1UKuxonz3m7ojtuKp4aZNiK3mOOYH0vNN7huLt1DjX0s/Ej2eI1NyE7YBLOKrH
	 wAS7VHHLwsU2SaiN9GT2t24fZRVqJlNGLVYaVuzbevijQLuM65YzCE84RGFL10SuITAoE
	 TA0doHrGOCtTJoqjd1ahp36wlwDkcHSwAYjYtwgDoojIOxO+L7lHu/4s4V9tiT+QnDg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 2AA161F000CB;
	Tue, 20 Oct 2026 23:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792540403;
	bh=Kel4RSYESjXcs8Dg40JwYXjmWcDIJY09nOoIQY6d2LQ=;
	h=From:Subject:Date:To:Cc:Reply-To;
	b=NL00w4KLJBC3iawsBoUNIOGnDmsbentUZwRLGedSaHsGa9t4RVY2KjUFffgp27rPQ
	 Z40ynxLvfdl3x/j66cgPICq3uWnf8WuCulSKp0FUofWyQOLCtgQWpKf3JIbckTiJLg
	 l8hJ8AUXxIZhVUuy3n//6G8hriAZdCmDv3SJ/PEvXctWP5HbPFau+S3CR7EfCD38/S
	 uC8TBOm8vPUZfqugmaUDVfsD7iPeYHkr8QD6kw6Wyamm0KOstP1GnK42B8XRrFHbWn
	 6aAbwTc0w94fv3xyrBds9AcvF6pcyzFRU685VL3lTGWteL6B/7WT7Yj051nQrbGFsV
	 Yn8/elM8VaQww==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 7EC4543263;
	Tue, 20 Oct 2026 23:53:21 +0000 (UTC)
From: Michael Reeves via B4 Relay <devnull+michael.reeves077.gmail.com@kernel.org>
Subject: [PATCH v2 0/2] arm64: Add KVM support for newer Apple Silicon CPUs
Date: Wed, 21 Oct 2026 10:53:19 +1100
Message-Id: <20261021-apple-m3-m4-kvm-v2-0-04905152cc2a@gmail.com>
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
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAO/+12oC/3WOQQ6CMBBFr2K6drQUAurKexgWnXaAKgXSYqMh3
 N0W1i7fzP8vf2GenCHPboeFOQrGm3GIII4Hpjo5tARGR2aCizLj/AJymnoCm4Mt4BUsYIVXFJQ
 XqDSLrclRYz6b8VHv7N/4JDUnTUqg9ATo5KC6dNJONvN5127C+E6xzvh5dN9tWciS7v+IkAGHC
 rFQ2OS6zPHeWmn6kxotq9d1/QE4rRLf5wAAAA==
X-Change-ID: 20261008-apple-m3-m4-kvm-b7b9b2e34bcd
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Mark Rutland <mark.rutland@arm.com>
Cc: Myria Sarvay <myrialsarvay@gmail.com>, 
 Yureka Lilian <yureka@cyberchaos.dev>, Fuad Tabba <fuad.tabba@linux.dev>, 
 Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org, 
 kvmarm@lists.linux.dev, Sven Peter <sven@kernel.org>, 
 Janne Grunau <j@jannau.net>, Neal Gompa <neal@gompa.dev>, 
 asahi@lists.linux.dev, linux-kernel@vger.kernel.org, 
 Michael Reeves <michael.reeves077@gmail.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792540400; l=1504;
 i=michael.reeves077@gmail.com; s=20261008-m3-m4-kvm;
 h=from:subject:message-id;
 bh=G8igJOGmolem0kocmF21BJtoXeYx1AMIyTFUWr2XhNg=;
 b=3/imRnUx82pjDBOxQMAxCwDKByTwQ/pGjZVTqRy7jTjfXcIpKtcapYnyJgcn0m0DpETbDD76T
 CByrM5Dp/QaBW1o/MLetC4O2gExoXOB0vaJrXCtXkvMWIPOsb/Elnyr
X-Developer-Key: i=michael.reeves077@gmail.com; a=ed25519;
 pk=oi7WuppQ1A+qFZp9DdfIwDnpC3WZ+XY6fJK1upV/CSY=
X-Endpoint-Received: by B4 Relay for
 michael.reeves077@gmail.com/20261008-m3-m4-kvm with auth_id=1131
X-Original-From: Michael Reeves <michael.reeves077@gmail.com>
Reply-To: michael.reeves077@gmail.com

Hi,

This series enables KVM support on Apple Silicon M3 (base, Pro and Max),
base M4, A18 Pro and M5 Pro CPUs.

The first patch adds the CPU part numbers and MIDR definitions.

The second patch adds these CPUs to the existing Apple Silicon PMU and
broken SEIS workarounds. It also enables TDIR detection so KVM can trap
guest DIR accesses without trapping all common registers.

This series was developed from testing on:
- Apple M3 and M3 Pro by Michael Reeves
- Apple M3 Max by Myria Sarvay and Yureka Lilian
- Apple M4, A18 Pro and M5 Pro by Yureka Lilian

These tests also confirmed that the SEIS workaround is still needed.

---
Changes in v2:
- Add A18 Pro and M5 CPU IDs and workaround coverage.
- Add all to has_vgic_v3 for TDIR detection
- Document testing confirming SEIS workaround still needed
- Link to v1:
  https://patch.msgid.link/20261008-apple-m3-m4-kvm-v1-0-7bb4cbf3d63b@gmail.com

---
Michael Reeves (1):
      arm64: Apply existing Apple Silicon CPU workarounds to newer CPUs

Myria Sarvay (1):
      arm64: Add CPU part numbers for newer Apple Silicon CPUs

 arch/arm64/include/asm/cputype.h | 28 ++++++++++++++++++++++++++++
 arch/arm64/kernel/cpu_errata.c   | 12 ++++++++++++
 arch/arm64/kernel/cpufeature.c   | 12 ++++++++++++
 3 files changed, 52 insertions(+)
---
base-commit: a90ee4305c4a5df72c11b31dacfdc76e00fcf78a
change-id: 20261008-apple-m3-m4-kvm-b7b9b2e34bcd

Best regards,
--  
Michael Reeves <michael.reeves077@gmail.com>


