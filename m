Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794231279;
	b=SYmlOqzU3TGYap5XuN0lRR3lzg2xJkewl/Sy1pvT/jFMiPVkGynhHUUbMsd1hmHn3EkY
	 zuArnEctG8LD8ECUIskidYrnU2jgzrg5sPsfubEyQGIQRARmf3y1ejhW8VtaBrFB2G3Zf
	 Vnp5J0dOT9EbykKh/uGQoEK9vjy40QU92RP1/nlWNz9umblaBknzvJ3dGv6wkoC8NZxei
	 5Zh1L/Bf1mIzfy/b1bcQexAuDWyXx5jtYcRUcsAg8qpfy+2oAxc2eFzB4JLX0wk/uzXjY
	 8npNWIzvGSrhoJ4s8G1QeHwQ930xRbm7TD9yS/mVQ9IMAhQZk3w/6Q7w8Ei+F6ct7cA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794231279;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=ORer9DhCnuaZoXr0bk+u3MIlDvmVjzbI7uxg7VutLSY=;
	b=a4WYvpCNoCdtq+09zc4GFyBjGD/MLaRP3F2+jfW6khlUt8w2VVs5LbSeMi1vpUYIPHSa
	 OXCAT0m6kIjuWALmxnN0RLX66xKbCVhWErfsXHOIzTtk5tb9n+ZYHADh+/N49fsK8RaPJ
	 ZlejQX3YC8XpxJ0mS/HNyt/o3PZa5WDhOlwdstYMzath7RkVjzgK76kT7OZUucE0Nnjws
	 hWzieTjsRbLW3fIwFGPOkjbI0I55T3jGwHD/oqtm9az05jlJ1/cTK4IrA4a/M6qfMroY1
	 wbx0JeLjByoLg6fztg2k0HrFoxh01uvZ041pB4Xqim3jAltKd1Xm0DeJyTnm+w27JHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=KFZLNuWU;
	arc=none smtp.remote-ip=209.85.221.42
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A649606A321
	for <kvmarm@lists.linux.dev>; Mon,  9 Nov 2026 13:34:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9A649606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=KFZLNuWU
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-490d59c3f0aso436569f8f.1
        for <kvmarm@lists.linux.dev>; Mon, 09 Nov 2026 05:34:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794231278; x=1794836078; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ORer9DhCnuaZoXr0bk+u3MIlDvmVjzbI7uxg7VutLSY=;
        b=KFZLNuWUGxVc44FDj5Zo8Y7EEVPsegRFBNsd/tmOkfuR4DNzIAKlkMC7QvPdGMW6r3
         6P/mCactH5TAHcO3spuz2DfiigKJ3V9nOks+yn7lNyZerc8keCnuCXATeH6Y3t/JRt6Z
         2jKU5f8y07tSosXNvDs/tmh4BSNRxJvMDaZeIr+7BcYM77QIymsRvbTJyUUQmhJnS8bS
         rart07qK6TThIAdFm34U7oLV0pxhOVd0c0PRAsLRaWhK18dSwRKQt1fHKqouuptgSfmU
         ztvHs2VrT/HaXhsF1HwxgSPQD8lRnyW6aBaJYxNPkN6u2sZc3Kfzwu83v6nWA3vPZfGL
         HoPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794231278; x=1794836078;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ORer9DhCnuaZoXr0bk+u3MIlDvmVjzbI7uxg7VutLSY=;
        b=w8+WJ9Snal8POCR1T2aGu/ZNuOmcqSnaGHsMINXXDpcIUeitf0refWnmjzkFkBF+TK
         7SVWjgE4RCUcHggOJtkAAuo778+2NbviU9j8iteBhxo1cNRUBWIdfdQCchVlwp19lmHz
         uy2EPo5PHt6DXPDdzcVrNeSB0xwHwbkwdcjLiaqNZcmAcWZKLx0IRtOB+pe1P0rkST//
         w0x5af1J9zp51AqIDpv/TccT5FBWyfUvLyhM2k7OOTiKcDDCKOB8etkyWR6pVZzL/UI1
         Kdkdr72CFiEbyoi9hRptswrCncqj8BiVaoYq5YsjM3sZb5kGU5dagIDVyozqURw9xy5U
         WHrg==
X-Forwarded-Encrypted: i=1; AL+hErF682y7yl9m0GNJi+QyI/6e80siyTGnliKKBEILq7sLpYrrv+3DlgupJ0hIHbXVMa1RU3rJ0rE=@lists.linux.dev
X-Gm-Message-State: APuU4Z+CU+e1h8hr/RzPztC+0D+5ZOp2/PAezGlaN7dAvxxlOn8xwZaV
	W33LYpBQ9SFaP+d/w3GEvqitqXIeRPlvCmX4p/g7HVtYoEofSZV3Spgh
X-Gm-Gg: AYBFou08n5mXpAEaKxwOf0kwPA5dLMWqwVcduBNZ6JkA8vqvvUwC2tgkNIKgwg9lEWk
	C6be+PaeRsD83FW25QY9TkSO/iKg6Cmb6tozaaOomHEwbksuwbCSmxEhjJ3YDDvNQ4BAQX1IOxV
	MCwjWoZCrRHw64BXK1aKvJOJZ2LCLvwjpN3NuRSO/VdXG5WEEMRenM82sj38Su6HEjJye6sPkku
	vfVhrW82W1tX2Pi3j4LqcsZMet12VqkmusK5rcs/3Y0YxUl1mUdxupXPRo+P/SlhX3A9BUne4Aw
	0KzMO3ydYVBJBf1Hh6pI4+C1K8+ch1MwHv1JYLYYteKxh9lIBOtACruMxDTEIlx2pxLX4t2DjeT
	SxXbhxWCm/9cnl3HshRNFD1NXklMB3odTCjTMuCP+kLbnn3fgp0vBymniJqGyotg0piDKuf8ApT
	myd4jcgdQ3X9c+9tx9coKGuX0nHSiu5mLAcQLvD9HJfmEEIVSMis9DU9xfDMI5RxWsfNZ4N0hJ/
	HisCnu7hIKzicj3U7BaAuOja+fYzMnTktQPwP3Ud2j/PFqJQPSOro2G/oNS9nn6TEPjLnodsd4k
	B7adzMPS6mc7KcQd5rq+K6Nl57w+6IWHdAYB1zPRMzP7+ESRsAOQnCvxBc6niCgNSvq+2Lzdo/K
	HZeZ8PenGCyiUzWpjx6P9ICCbVA==
X-Received: by 2002:a05:6000:1789:b0:48e:6f76:de98 with SMTP id ffacd0b85a97d-495829c1025mr7989710f8f.9.1794231277701;
        Mon, 09 Nov 2026 05:34:37 -0800 (PST)
Received: from PKL-HASEEBA-LT.. ([39.36.57.162])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49592f39899sm9140435f8f.3.2026.11.09.05.34.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 05:34:37 -0800 (PST)
From: Haseeb Ashraf <haseebashraf091@gmail.com>
To: maz@kernel.org,
	Oliver Upton <oupton@kernel.org>
Cc: Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	fahad.arslan@siemens.com,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 0/2] KVM: arm64: nv: Skip empty spans when unmapping a shadow S2
Date: Mon,  9 Nov 2026 18:34:29 +0500
Message-ID: <20261109133431.185154-1-haseebashraf091@gmail.com>
X-Mailer: git-send-email 2.43.0
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Emulating TLBI VMALLS12E1IS, emulating TLBI ALLE1IS and recycling a
shadow stage-2 all unmap the whole nested IPA space in chunks of the
largest block size, even when the table is empty. With a 48-bit PARange
and 4kB pages that is 262144 unmap calls per shadow MMU, each ending in a
range TLBI when FEAT_TLBIRANGE and FWB are available.

Measured cost: one full-range unmap of a shadow MMU takes 0.87-1.06 s on
AmpereOne (Xen on KVM, 4kB pages, function_graph). On Graviton4
(Xen-on-KVM, 48-bit IPA) a single VMALLS12E1IS trap took 1.46-9.50 s over
twelve samples (median 3.09 s), all of it in stage2_apply_range().

Patch 1 adds kvm_stage2_unmap_all(), which skips spans covered by a zero
descriptor at least as large as an unmap chunk, keeps the tracked unmap
for everything else, removes the guest stage-2 records of skipped spans,
and ends with the VMID-wide TLBI that VMALLS12E1IS requires. It converts
the VMALLS12E1IS handler. Patch 2 converts kvm_nested_s2_unmap() (ALLE1IS,
whole-VM unmap) and the pending unmap of a recycled shadow MMU.

The series is based on master, which already has the guest stage-2
tracking. It overlaps with the unmerged kvm-arm64/unmap-vmall work, which
defines a kvm_stage2_unmap_all() with the same name and signature; if that
lands first, patch 1 becomes "skip empty spans in kvm_stage2_unmap_all()".
As far as I can tell, that WIP helper does not touch the guest stage-2
tracking records, which this series does.

All twelve Graviton4 samples, in ftrace order:

  22) $ 2278347 us  |  } /* handle_vmalls12e1is */
  21) $ 3229689 us  |  } /* handle_vmalls12e1is */
  13) $ 7244813 us  |  } /* handle_vmalls12e1is */
   1) $ 2950198 us  |  } /* handle_vmalls12e1is */
   6) $ 5785126 us  |  } /* handle_vmalls12e1is */
  25) $ 2484152 us  |  } /* handle_vmalls12e1is */
   4) $ 2505404 us  |  } /* handle_vmalls12e1is */
  16) $ 1464441 us  |  } /* handle_vmalls12e1is */
  28) $ 1935604 us  |  } /* handle_vmalls12e1is */
  19) $ 9495486 us  |  } /* handle_vmalls12e1is */
  14) $ 4151658 us  |  } /* handle_vmalls12e1is */
  18) $ 9223579 us  |  } /* handle_vmalls12e1is */

Tooling: the patches were drafted with AI assistance (SiemensGPT).

Testing: build-tested on the master branch and
boot-tested with Linux 6.18.29.
