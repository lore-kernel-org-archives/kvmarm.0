Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795793507;
	b=3tNJ52cZjEYzlpA4QRqHXfGA75QcZIPxH3gOBeBtd/UkAGphObH6zqZWsTvAEFgPjrIu
	 mPKsRSMnwMGbWr5r7bWh/rT8L4ZDtAUqBhE/+/281eIjQX+LsK24nrumu5GUrV523vNP3
	 qPMo93RIzw1TtVPY+bcb+Ywj4fYbeiNarjbQd4hQkDdXxacYEdry5dJt71644X+gQ7VP6
	 3c6w/xT0nY2Nl8emzybolkFUud0r6rudj0vHepCFduRWYoz35WrJHxUpYeMDTFwZNaIEC
	 /31rTQRPvOrZSP4K5OJ2xJPPRlm93EGWOxAuxQRtMTHa7PM8PsWiWLIWay/8bmaRmQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795793507;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer;
	bh=Dshu9qpsSYZT8eeZu5f7BohnpZTCm94WxOmlyxYqBw4=;
	b=LiuVHeUHy6vTXIDBl+eD5PeXzW0PKkkil/QvjWlKfoa4opoj2fjT0aKti39G/OH6rWul
	 hXfciuXZ+f/rE7EFNKcLrOukBg97DO5+K/pZK2ZglGhyD+j6O4JWcmucDEs8WPXULEUqX
	 qMG2pP1ru4oNX/cyR3W0OHy+epZm/aCoNbHCVMG2wUJxhTlOjPdQltJ2LR6bi+4kR8sYg
	 G1nhmUJshtwo41rOrwJLYlOJiAQGdnfnRiw5nK9ORiWL7cwxVlDj4xv26migOztf58zdT
	 cG93uG6XqYue51NFjeoUIjqv21R1idDvF54Aa13Xhof8kbarldndMvBZm6FT6b5ENMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=pereq.eu;
	spf=pass smtp.mailfrom=cryspen.com;
	dkim=pass header.d=pereq.eu header.i=@pereq.eu header.a=rsa-sha256 header.s=google header.b=LqMwTZUR;
	arc=none smtp.remote-ip=209.85.218.45
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71BE9606A321
	for <kvmarm@lists.linux.dev>; Fri, 27 Nov 2026 15:31:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 71BE9606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pereq.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cryspen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pereq.eu header.i=@pereq.eu header.a=rsa-sha256 header.s=google header.b=LqMwTZUR
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c4d2b741ed9so1317480766b.2
        for <kvmarm@lists.linux.dev>; Fri, 27 Nov 2026 07:31:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pereq.eu; s=google; t=1795793505; x=1796398305; darn=lists.linux.dev;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Dshu9qpsSYZT8eeZu5f7BohnpZTCm94WxOmlyxYqBw4=;
        b=LqMwTZUR5zVLVeBFwlkrRanSF3KkWTrl7631w5IzW5bGgHG7vw/0kBIej7l9UvJweU
         T0L9pi95MfBudOydgmiNIvf0SXgynSOYefTah82MTmy0haA1EIWmM6C+2aBGlD7gW1AX
         qC4xlqhDn4L1Cx/tWw0DW8UHiUWq+Bgk8wxLodODpgOeEZVZYRjS7i+jhGnDYmX5nljZ
         EHJCf7D4jFoditcz/DU3uwEbUe2PXj0y2mBt8ppIyP/DF5YsyF+8NgW/PvXmX3bQwTO9
         ByEUwd5GnWA32QL4cn8sSAeH4zwmWrmv28VAwD1mcvjqI1vgd0PWaxH17B5hiMzXUVtk
         KgCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795793505; x=1796398305;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Dshu9qpsSYZT8eeZu5f7BohnpZTCm94WxOmlyxYqBw4=;
        b=VC35UyunCCOP0KXVWvdtMH16/DHHsK2wat6F0pkWLixA1VtZ0/fSMh4nV0gQ5VNdW+
         ZmkZyLrQo7rkBO56f2l3z3yfG8gNBPh4jaPO8TpN3nh/YmGvcSJXI3EkrDZTOWgU0gKL
         L+C/CPsHtIq48x8E9IiBUwMDPmW23xMwvbCq1eoy/cw7olVaKAWvWDRuZuMB8P5JzQNi
         R8R3TGH7omQ9b42H4UGl5ejgRYoU65OAgR6NvH9b9+BDbFF+MdI65NNiooD8h+30NE0P
         F6oox3E4wjqFn8p48dn+CD/uePSZTw1sCZeG+qCxJb3Cu0khYtH0B0qI8kL+onkOsLwO
         khAg==
X-Forwarded-Encrypted: i=1; AL+hErFHLFcRgPdI0ce9YSIRR7zANk7mjtwD9OEZbJAF0zfg6lX+Rdh95Hwk7/+GawxJXFQpxRauU+U=@lists.linux.dev
X-Gm-Message-State: APuU4Z81hOYX+tgoLu1Hj7odyytCYlA2tT/bXtXWkNaGUrKduNaCkpDF
	IqB9Z4xRStgD8mOtX7ax5Qblq7b24PUhg6UughQgl46WKRW9ZfHOT5wisncG1WpfFb0=
X-Gm-Gg: AZFdTZdK5V/as44d0zZPA811HwGfu2uOfiQ6z0/oFeRFD8e+tcxd3Ma9LJQbgRW17AT
	YVquAXSf92l+8SfdMb/+PfxooIjgByiF+ZZwngRnuxtSdChAMTq+J0D5ZVcLn0np7tamIP050Sh
	23zeWHO4kES4fJDusUc4RhEu+N4aSJ2Mt5DYrExupCedsR/s+2xkO+45vvvySYb9fWWs95pQRrP
	00/oqdhU1QzUhSJwXFKJ35ixzOQKybzHHntjCb/NzLYs2tkV6+SOiEcuWwCVBM225PFZPLx4Ody
	zXRw3QwzUB8Zz4n5Br4V6qzQ7kHeQkWycnD07ypy1jQN2xfZJ2esfU23eqOAp5PNjAgkTb+B3A9
	kIPvOmHJjhlHeMJRmTpusudTuXC5jq1efUwcOjWyEuhdYhLeixRAG337vQrm+3yX77P0vmye7R8
	1fVeUB3XERPb7QbGFWO9FPoNA/uVCjH7275q5X+ebhJ/0nAIhInPq3Gn9ljADDD+WqIGLNMRzFR
	GgspJoU8Qj97n4zwts1XqpXQQ1yi8C4nzSD3fTrPRLYPVc5RdTKaeoi3axJ2Xn6Oxkm4aWKH9/K
	3znX8ePgxUDqRkwUwb8=
X-Received: by 2002:a17:907:9584:b0:c34:e9fe:82ed with SMTP id a640c23a62f3a-c513a88223amr1963994966b.28.1795793505180;
        Fri, 27 Nov 2026 07:31:45 -0800 (PST)
Received: from localhost ([2c0f:3d00:6be:8900:ce5e:9212:ea4b:f30])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab6baa3882sm47092498f8f.49.2026.11.27.07.31.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2026 07:31:44 -0800 (PST)
From: Dan Carpenter <dan@pereq.eu>
Subject: [PATCH 0/3] KVM: arm64: nv: Fix AT emulation for nested
 virtualization
Date: Fri, 27 Nov 2026 18:31:37 +0300
Message-Id: <20261127-nv-tcr2-v3-v1-0-9c15c1cabe01@pereq.eu>
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
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/y2MTQ4CIQxGrzLp2hqhotGrGBdQq1MXaOhITCZzd
 0Fdvu/nzWBSVAyOwwxFqpo+cgO3GoDHmG+CemkMfuN3zvk95ooTF4+VMJBw2IYDEUVoh2eRq76
 /stP5x/ZKd+GpG/oiRRNMJWYee/R3rZurN7AsH6p+2A2QAAAA
X-Change-ID: 20261127-nv-tcr2-v3-53ec5459333a
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
 Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
 Steffen Eiden <seiden@linux.ibm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Mark Rutland <mark.rutland@arm.com>
Cc: Karthik Bhargavan <karthik@pereq.eu>, 
 =?utf-8?q?Cl=C3=A9ment_Blaudeau?= <clement@cryspen.com>, 
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 Dan Carpenter <dan@pereq.eu>, stable@vger.kernel.org
X-Mailer: b4 0.16.0

This series fixes 3 issues found by our formal analysis at Pereq.

* VMs were potentially using the TCR2 bits which weren't intended for
  them.
* It turns out that guests could write to the TCR2 bits even when those
  bits are "hidden".
* The VMID wasn't handled correctly.  Roll over could happen before or
  during the AT execution leading to invalid results.

Changes in v3:
In v2 patches 2 and 3 added traps to prevent writes to hidden TCR2
bits.  Marc didn't like this approach and to be honest, the patch
had other issues as well.  Marc suggested that we load load
PIR/PIRE0/POR unconditionally instead and that's the approach here
in patch 2.

The other thing is that I have been trying to improve my review
process so I ended up fixing a bug handling POR_EL0 in __kvm_at_s1e01_fast().
That fix is now merged into patch 1 since it feels very related and
it gets backported to the same kernel.

Changes in v2:
1) Sashiko pointed out that we need to restore the original TCR2
   bits at the end of the AT command.
2) Clean up based on Marc's feedback.
3) Trap the writes to the TCR2 registers (normal and nested)

Signed-off-by: Dan Carpenter <dan@pereq.eu>
---
Dan Carpenter (3):
      KVM: arm64: nv: Fix AT emulation for TCR2_EL1
      KVM: arm64: Load no-access permissions when S1PIE or S1POE is hidden
      KVM: arm64: nv: Update the shadow MMU's VMID for AT emulation

 arch/arm64/kvm/at.c                        | 61 ++++++++++++++++++++++++++++--
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h | 40 +++++++++++++++-----
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c         | 15 +++++---
 3 files changed, 97 insertions(+), 19 deletions(-)
---
base-commit: 5a7235e9adff42aa043ac9473dbeb0354dca0967
change-id: 20261127-nv-tcr2-v3-53ec5459333a

Best regards,
--  
Dan Carpenter <dan@pereq.eu>

