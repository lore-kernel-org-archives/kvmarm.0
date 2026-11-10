Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794329236;
	b=DIWLzB6n1ZK7IVVOTHj8dJJAb9SfUEevFWDouAoFU0E3UPkZKyecb+278CIgnqpzP4GB
	 jgSyYnlAJ3HCgRxCP/Ei/bAkSxf2OS2N0sVOQAq/Op5R046id84Oajx1DUGz/W2gG2R2H
	 Gb7ZtVWIup8VYnkGrn8MZaiXl4RQO3EIU89OnoC9TW7NvFGe/OtFrjPL8ol4/XVwBL4Y/
	 iq3GrpCjGbh6JhHT0Oly3GS/9Ah5+Ax3LQnlYtpEUQSP6B1MzG636U9FEfxeDQnngyqRl
	 9nqgtuMC8rX4C7dmPejQyxc1E2fbO2D1JeKB48ekYpeeEC1RhoOpluacKSXMlCL443A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794329236;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=WT6C7Hu6Q9Eo/dM1QL4EzHwS0urSyLblqYy3glwBl5U=;
	b=pcmLZxBSnFquXDAS9i3ypAKanfm4B07GWBK8+8YkTVONlp9GlxIGKVYfoN+WNMDqJBlx
	 +S6RVrZ/H3EInD/W+csbYgdLI5cd+CCEQXbuZnq2tZjUa7AgfqHco/ODvNDLxo7Z2+VDj
	 L5hr74plW46uT7qiRXvJZhhIpuFE5RI+zYasLl02XAl3cINuLsGe5+hwVBLV6rZ2jJwfJ
	 lwKxwN/c5wLjxfD952rjdvopgBVBavAo7aUoFD9p9zSh/Eukjs7zfnUwnsuABDlyiTxhS
	 MmJ6s/E1D9DP2pZiiIZ5it05Kofn9OTBOBtjhhoWNSnh6SRhHgDwH4UfF7KhPoJW/aA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=WY5ToL7y;
	arc=none smtp.remote-ip=209.85.128.47
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B285606A334
	for <kvmarm@lists.linux.dev>; Tue, 10 Nov 2026 16:47:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3B285606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=WY5ToL7y
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4a20a37703bso16467395e9.1
        for <kvmarm@lists.linux.dev>; Tue, 10 Nov 2026 08:47:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794329234; x=1794934034; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=WT6C7Hu6Q9Eo/dM1QL4EzHwS0urSyLblqYy3glwBl5U=;
        b=WY5ToL7yQdUHX8Ab37xmVm0vS6bJghds7MCMvypysUb4G6dtmapzP272h/Tq/ravkr
         vpxjUSL4e19SJuDDdHH3omzneNNfKYS/weWKoTNRpzQ3sG54FqOvHAMRDqCeSCYdgqGU
         Ylr0imW42kzkHT9ymD94LIZa1iH4FyChSe8cLr+NW97r/gRg6NliPSBPDD+nzrPR/6Tk
         /kB3bYT1IwjvGlXgO2xHSyKSY+UgoKClmQUQeePMuKNheoj8Mb1Kt4tX+Fq18bUi+sit
         zGD5DqOA/V9iSXS4A9Gi0TzgRljmvOf9t1xzFn9ux5YLbz5GnWZw6nBCUtIWgPwnyPFG
         G6kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794329234; x=1794934034;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WT6C7Hu6Q9Eo/dM1QL4EzHwS0urSyLblqYy3glwBl5U=;
        b=hqcpCmSFs68ruOtcyYbw/Syt+L8SqRKXwKXO0+vau2zEyA+6/K4AJQq/9aOdLUAc3Y
         vbkesU6IlLW3yBfiqZmOJ8AUSewULXEQ3Bo4XD1gmOR7bsLBAb4TnEX8/vRoTNuIUYV8
         ItcGfDrnDuSordlXVkNDzV2jMSGkxXnO3KR9xAuseLNEwElnF9fmsUhSw4mwen+Q22bp
         fkiMYDNj+LFhwkLwQd8WwaEqU+Uwiogy1FHsf2wktsvX7hrMMZWyDaOZ6L0p1Nv6TWps
         Bfiz8eSAVOKch2MoZLVGUvfqOLGqnqz7VrVPKORpgkKOs0eab/Zn50YFoO/MlLk1qljR
         aFbg==
X-Forwarded-Encrypted: i=1; AL+hErHtRNPKmzmx8pVKuyxEzFdRjtTcdmlmZcw8E5KIQVeNdGDSR7efVi6vRLBbOkxkkAgMINR65pQ=@lists.linux.dev
X-Gm-Message-State: APuU4Z+jivKH0fVTtAjaqUbaavSw4PNljjU2+EH1b05nmVByi0p95/JL
	wvw9r3FuPtH5u3rgZ2JU+iQ7MHinnWD44daHBS87PDaioI8zMkmeMfQU
X-Gm-Gg: AYBFou2ViUu64CkbZQjUbFHjZoPUMCamKzXVzcZ5DRtG0wXOdiH8X8rySdE+KSgKgQ6
	gTvzwmDL06vlw4Ue3kd3m/q50RSq8ZWoOnZO0hBOet8N2TugTb3wWPnKDSZ7tSOjFe0I6o6AVuD
	krziQ4C1R+r90al0TGNxdpTmEXdRoNeZ4AqEpFA+eVoj+84jkf3ulpbiroh4FenXF9k0r1/Jkkx
	6n2D5R2hsXsGvctOHyJEXvSgCxkMRXwQEDzOAngoJQ312vs8FH2+2HtOAD9gjBD8cPMCAMA4nvK
	N7YArbe/2rc0NOyw6c6JwqQdyZikk1DrAeMqDfTHhR5jaNU9sAhs1DaXYzkzNNoaJkqgA8kZgju
	OjIEklW4VZmuDgVMDjb9fhPTCe1vtcU9H5shqG6K8p6w8M8Mb1D/YNnMxe36SRXa6tvg59iPuYL
	IU+UQH+qQpStC2ilAugaEer2Lt0jdhzl2VzhFI0DIUay87ZHZooj/qUyFAIkV+xhIMy7JLhTvZ+
	lAgojNp84CTJSKYZOOjWMXK3B+BZhpKWY6oWs9FkPaZUAZCNlX9vbNeEhCLJqlyC7i2ZbYUkKDs
	10uRT4tNkoRcAYzknJg9Q3Xmyk5K76X8+r7LzYH9hEqhtH40d4UcgjtdHjtWhT49AV3qI5gh7pm
	LwEqDUievsmtf20gt9gAqKurk
X-Received: by 2002:a05:600c:4e8a:b0:4a2:fd2:985d with SMTP id 5b1f17b1804b1-4ba02345745mr59161225e9.12.1794329234174;
        Tue, 10 Nov 2026 08:47:14 -0800 (PST)
Received: from PKL-HASEEBA-LT.. ([39.36.65.144])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4ba01fe9357sm84905075e9.9.2026.11.10.08.47.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 08:47:13 -0800 (PST)
From: Haseeb Ashraf <haseebashraf091@gmail.com>
To: maz@kernel.org,
	Oliver Upton <oupton@kernel.org>
Cc: Fuad Tabba <fuad.tabba@linux.dev>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	fahad.arslan@siemens.com,
	haseeb.ashraf@siemens.com,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/1] KVM: arm64: Resume stage-2 unmap where the walk stopped
Date: Tue, 10 Nov 2026 21:47:05 +0500
Message-ID: <20261110164706.582879-1-haseebashraf091@gmail.com>
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

Unmapping the whole IPA space of a shadow stage-2, as emulating TLBI
VMALLS12E1IS and TLBI ALLE1IS does, walks it one block-sized chunk at a
time. The walker steps over an invalid entry in one go, but the next
walk starts at the following chunk, so an invalid entry larger than a
chunk is visited once for every chunk it covers. Each walk also ends
with a range TLBI when FEAT_TLBIRANGE and FWB are available.

This version follows the approach of Fuad's series [2]: the walk reports
the address it reached, and the unmap loop resumes from there. The walk
already handles every entry it steps over, so nothing has to be looked
up beforehand.

An example shows what changes. Take 4K pages and a 48-bit IPA space.
The root is a level-0 table with 512 entries of 512GB each, and a chunk
is 1GB:

  Empty shadow stage-2
    before: 2^18 = 262144 walks. Each of the 512 level-0 entries is
            visited once for every one of the 512 chunks under it.
    after:  512 walks. The first walk under an invalid entry returns
            the end of that entry, and the loop resumes there.

  One populated 512GB region (RAM and devices low in the IPA space)
    before: 262144 walks.
    after:  at most 512 + 511 = 1023 walks: 512 chunks inside the
            region, and one step over each of the 511 other entries.

The example is derived from the page-table layout. Measurements follow.
The machine is an AmpereOne A192-32X (192 CPUs, bare metal, 4K pages,
48-bit IPA, FWB and TLB range maintenance present) running Xen as a KVM
guest. The workload is one create and destroy cycle of an 8GB guest
under Xen. bpftrace kprobes and kretprobes recorded every full-range
unmap (start 0, size 2^48), its walks, its range TLBIs and its duration.
"Before" is plain 6.18.29. "After" is 6.18.29 with this patch, adapted
to the older unmap loop, and with seven commits that are already in
mainline backported: 33346f8960c7 and e5843f4effaa (nested_mmus life
cycle), and a6ca6cba5959, c2778d14cd2f, 5491980c1a41, e6084aecaeef and
2064f15b0848 (guest stage-2 tracking).

                                    before          after
  full-range unmaps                    192            128
  walks per unmap                   262144     512 - 1024
  range TLBIs per unmap             262144  same as walks
  unmap duration, mean            907.8 ms        3.77 ms
  unmap duration, median          909.3 ms        2.46 ms
  unmap duration, min             815.5 ms        2.06 ms
  unmap duration, max             937.6 ms       27.8  ms
  VMALLS12E1IS trap, mean         957.0 ms        3.78 ms
  VMALLS12E1IS trap, max         1848.6 ms       27.9  ms

Walks per unmap after the change: 512 (10 unmaps), 534 (1), 546 (78),
1023 (38) and 1024 (1), mean 689. The page-table occupancy was not
recorded, so I cannot tie each count to a layout. 1024 is one more than
a single populated region gives. Before the change nine of the 177 traps
unmapped two shadow stage-2s and took about twice as long; after it
every trap unmapped one.

Patch 1 adds kvm_pgtable_stage2_unmap_range(), which returns the address
its walk reached, and has the unmap loop resume from there.
kvm_pgtable_stage2_unmap() keeps its return value for its callers at
EL2. The unmap of a shadow stage-2 also drops the guest stage-2 records
of the whole span the walk covered. The TLBI VMALLS12E1IS handler,
kvm_nested_s2_unmap() and the pending unmap of a recycled shadow stage-2
need no change.

Changes since v1 [1]:
  - Reworked as Oliver suggested: the walk reports the next IPA to the
    outer loop, as in Fuad's series [2]. This replaces
    kvm_stage2_unmap_all() and its kvm_pgtable_get_leaf() lookup.
  - No extra VMID-wide TLBI: each walk keeps its own TLB maintenance.
  - Measurements added.
  - Based on Linux 7.4-rc1, the same base as [2]. It does not depend on
    [2]; it applies with and without it.

[1] https://lore.kernel.org/r/cfa77cdbf14d9fd24c22ab1ef9b940a0d7411699.1794229714.git.haseeb.ashraf@siemens.com
[2] https://lore.kernel.org/r/20261106133000.453240-1-fuad.tabba@linux.dev

Tooling: the patch was drafted with AI assistance (SiemensGPT). The
statistics were collected with bpftrace, using kprobes at function entry
and kretprobes at function return.

Testing: the backport of this patch, together with the seven commits
listed above, was booted as 6.18.29 on the machine above, and the
measurements are from that kernel. The patch for 7.4-rc1 itself was only
compile-checked in isolation.
