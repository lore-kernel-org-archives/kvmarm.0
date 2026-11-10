Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.217.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794322062;
	b=HxPM0j2yEMSd/PUV12piYvQhLUaa6giz+yrgX49xOKWEq0ZLusGZlVBn7Y/8CGAC5Z7h
	 gxGI22/aIMdhytuf9s3/aV3/xsl/7G2G/G6x9/XCKG/m3umOQ43ludI/82dKmBAvH9/3d
	 FH9mIBJoStkQNsQI8EhG7Sgq3Pjw8RTBpLeCPh4Vscl1FtYE5+LdZEfx+QPsvCI3ZHiXf
	 d6WBOqHreo9aR9s9zufBTFixI5Py/BEqssEbneZ21vaxMnNy4T5NdeeLRmaa3tyfRFA7v
	 dgfjUIo5AJ4Q2PM3QBlDM30lZSU0v8W2WKdN7YelmoASWEmumhiwayVn1weTp0S9YdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794322062;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:Subject:From:To:
	 Cc:In-Reply-To:References:Date:Message-Id:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=ZFEAJe5RSOFhQbOQqwNvxFPxejburOXhpBzwnwwZqdo=;
	b=0CtfIQYAeAg6Q+9qDksPt+8q7Pma84CUbmY4o26uz5ZGbzBsoNtj0tTdnBSuPTY/5X8G
	 JRMMYk3v11Ca/dvhw3wUYhoZMj+3WsTC7Cb4YTkWRUulAk7NORPpoYQZ4yUlQg6EaCCrW
	 Ka5Yh4Hd0utmHivHpn/XMIzOLpkCmycMidnJ0W0nQCH0VyrvuQFbSfihy3VT2HK5Y+6XW
	 62bA6axewUqWsPzsuN3FtDez2oIPrS2I8OLeO146BPD12Ioibsfry4Sw7xonx1seInmqq
	 MfbNhYQmfIiYpiftZ0H+/MzcNvmULSZWkYMxu/62+9pKRmQ5LzsMjwOLqxFv9+sGrvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=soleen.com;
	spf=pass smtp.mailfrom=soleen.com;
	dkim=pass header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=UnlnATDt;
	arc=none smtp.remote-ip=209.85.217.49
Received: from mail-vs1-f49.google.com (mail-vs1-f49.google.com [209.85.217.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BD0960A2617
	for <kvmarm@lists.linux.dev>; Tue, 10 Nov 2026 14:47:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3BD0960A2617
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=soleen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=UnlnATDt
Received: by mail-vs1-f49.google.com with SMTP id ada2fe7eead31-7d2e14babc8so1203533137.2
        for <kvmarm@lists.linux.dev>; Tue, 10 Nov 2026 06:47:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1794322061; x=1794926861; darn=lists.linux.dev;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=ZFEAJe5RSOFhQbOQqwNvxFPxejburOXhpBzwnwwZqdo=;
        b=UnlnATDtPHdvCzldCvkxBcmvYqTOx3hAuIRFM2ms5GWBfUet33ZsXhBSZc2k447X30
         4AsESnj2o5ATywOetxo93wRnlkpDu2jQqEZ+0hxk6pXRpvZvISgJVLEYYEI/vtm87sw0
         11h5x05XUPRWClZUUmyqQJURmmD97CLpx/MchfnY0WUU9kXwCW0ZpHeayTQTgnHR8xKb
         SdUEMjSM9dXe/KQpDBDq+PS8C1FLZjIuF0QDK52VTMPvgmXAYqnoWXGQOyMUfnNsPBAx
         GS9xVA7l92Fwz1/W4rKw0481CZ09B7XJYpnpC3vG/lbGLFicwET2wuO/wSxGhr9Ac01M
         KWsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794322061; x=1794926861;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZFEAJe5RSOFhQbOQqwNvxFPxejburOXhpBzwnwwZqdo=;
        b=va0PRbPGMknLXDxdu06KsslFH9wYprHoVkE8RHCb8ZdnMRy35Dczco5nlctOrC1Ijb
         NSfF0b0dzKfhivDuNs54622WTK03ZJlPlQQJS7LU+3K1MrlMf7XxaBMzbDuT7wL9WxsN
         FEU6nbM+7X6qlKlmThd5fHCYvOENQvxhMkdxR0YDExvtygtfLZQoB/Iuk5qjfNWKtU2q
         6gBTZX5+WjQ4bgpzV8jeA5kdSn6AKKGvmeyNKmzBAmoTAw9VPSkM7Vi3lXF8TdpHOjxf
         m/gLfHTSju+uc0L8al23v9gPVfk99dlLWqbOS+f2FkVRvx9xRGkaBWj2lleA96D3Eki1
         MXCA==
X-Forwarded-Encrypted: i=1; AL+hErHpxbKYdOeYbYmYEYb8A8gBoceVDW8gRNAs273jTRbyOiiQzqKrcne16Q8/PYk0keH/OMSmG/M=@lists.linux.dev
X-Gm-Message-State: APuU4Z9goC7IFbDUZoCOOgLGRqW3VoNiJRmNAiwvl+DrU6Z5qFihNdrv
	dYtiCxS+PyH8LRzTRWHTaAvjSmDa0DrEe+TmSEYMA+3MMoOKBIW+uPS9P1N3zmI4EBg=
X-Gm-Gg: AYBFou2O8nXdXTVphz0KWSLhEgL6oNDNSViAZYwY/Ncy9WzyC1pSSWHpCVsrm8plI9O
	6y606lGasTYofYettP/G+17i4fQUY+U+5f5+IiQAR6oOlOqjT4rIQwicK3u5j+qoqCQZczJW3qI
	cNzsH58bfJ7FvMs+ilqKn1aF2IWyAZVnlAQxgCe+KkrDh9OByd/iRzuZJ6f15SYDqgUt3pC1C93
	/aL4c9fSm7Nj86XM5z+/2PvXsPc67SvKoArGHTdKZPGItF4v/G5fPtwY8m5JKDbU+Orflh99xcm
	M6iQC9oyaIDhHLxRAldEMjXKaFJd2kK7K4D0o9B01RxyTX0GwiU/oVBy7VCymOPArc7K6RE0KoO
	bkqEq8dWr3iq6LdusP1FIfWmmEFDpc0IjLyHFd5YX9yVYsBC+Qe58kUVQfPSEQOEQLK5awhHuvn
	KCu7TaymRjtMrMB8aEr81aDS050zmd4VO244f7/hRrOBhIG0juOuQDpPbFLWdL3xICEyfsVrvS8
	rYrlxFhIqpW6VD+CO0lkVtsLwa0xhVywQGV/L3a9B9nrLcAAaCIfCMlgplA6oMKuSjqM2Jpbwi7
	9k6fxSHy5azBLaXEtOCJV8tbeKGaXNMEo4ZHKXcLyLNKDhyetsk8c+RNZZnFSKVj/yQLXDhNqeP
	O8QrROSYf2A4CwwKXqLu7Cp12aHn0CxtCdeeeJldvL3V7L6k=
X-Received: by 2002:a67:e706:0:b0:7cc:26a8:e716 with SMTP id ada2fe7eead31-7d301c2b6b9mr1064638137.18.1794322061210;
        Tue, 10 Nov 2026 06:47:41 -0800 (PST)
Received: from soleen.c.googlers.com (64.167.245.35.bc.googleusercontent.com. [35.245.167.64])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-99c2003b37csm1895903241.6.2026.11.10.06.47.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 06:47:40 -0800 (PST)
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
Subject: Re: [PATCH v4 04/19] liveupdate: Reference struct luo_file_set_ser
 via serialized pointer
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Tarun Sahu <tarunsahu@google.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Mike Rapoport <rppt@kernel.org>, robin.murphy@arm.com, maz@kernel.org, 
 will@kernel.org, David Matlack <dmatlack@google.com>, 
 Alexander Graf <graf@amazon.com>, seanjc@google.com, jgg@nvidia.com, 
 loganodell@google.com, arnd@arndb.de, dwmw2@infradead.org, 
 baolu.lu@linux.intel.com, Bjorn Helgaas <bhelgaas@google.com>, 
 oupton@kernel.org, alex@shazbot.org, gle.com@google.com, 
 pbonzini@redhat.com, Andrew Morton <akpm@linux-foundation.org>, 
 kevin.tian@intel.com, joro@8bytes.org, kvmarm@lists.linux.dev, 
 linux-pci@vger.kernel.org, Pratyush Yadav <pratyush@kernel.org>, 
 kexec@lists.infradead.org, kvm@vger.kernel.org, iommu@lists.linux.dev, 
 linux-arm-kernel@lists.infradead.org, skhawaja@google.com, sagis@google.com, 
 linux-arch@vger.kernel.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20261110050202.529473-5-tarunsahu@google.com>
References: <20261110050202.529473-1-tarunsahu@google.com>
 <20261110050202.529473-5-tarunsahu@google.com>
Date: Tue, 10 Nov 2026 09:47:35 -0500
Message-Id: <179432205559.2329176.7688399969919556416.b4-review@b4>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=791;
 i=pasha.tatashin@soleen.com; h=from:subject:message-id;
 bh=qYrWWLSjrMyi3btEEyRhgD14ybrNmyQeqN8ETOUOvP4=;
 b=owEBbQKS/ZANAwAKAbt3KEzbc3reAcsmYgBq8y6LmPCnN2SrnZCSda58BBnTZsMnjk7g+kA/g
 6Wo/AVJiseJAjMEAAEKAB0WIQRBMaqT7LRvGvB/NmK7dyhM23N63gUCavMuiwAKCRC7dyhM23N6
 3qrED/9liUyRUpQr+Sv1ioZ2pUvLcetyB+2JoLxaB/0UYYNHqDXpwWtEHhSP3eAYwEET2WAzSzb
 cINjQ0UdR20OJBBxpWT+3R6jrxl6smFx5lA1+CtzCdBONdl5NiW3+NITRy2Ip//vGFZKdNjWFk/
 5Y0ii3L7iz6hVXT9R9y6mqGOo2TBCSa84xWnOGrVJ8ijAnCqgOeAMhmqVN+rkl/dWCvzMcCFZZP
 AYRuSxmCQaOa9GxsOttPL5pX10r/UbwioXQZu/aJ6RcG+ql2liIZFv1+3mcSyInleN3SlnUZOVi
 inOQM3Yp2D1a6ekPH7F6Uzb45X4qnnJ8DSfO2LkVSWgmzzpsKuXUePJ8Pe0a7FfO9mUYj5Fp9wg
 IxfJUyigWzzPN0aOcgePZcZBT4fLUlw+zQV3UGnfTiTzevMagmFWU2+B/s0Zt7u6TidXvFQsMFI
 6ZlD5aySuQGLYM3+UdGdp96SY6FEGgvqmSCG63zPbq7Y2WqSBl153diBep17zLt4CJ8n3Fd+YrU
 E2rPF9GR7k6MT1Qc2tSSvCCk+cTjcDt4Fm3op7Z6LrxP3BQDFa0Fh2afBgG5mCHbK8fSxd2uggj
 NuHbXeBNgQpe1vKYQQd97AUSoFlymseer2cfqgpdkxtIZwGdPAYPchrVuPHKx6mZDNkSz6VZZ49
 k5DwAzPXt9kz4Og==
X-Developer-Key: i=pasha.tatashin@soleen.com; a=openpgp;
 fpr=CAAAB722DD22A081F0D49F35633A6A993D43B569

On Tue, 10 Nov 2026 05:01:47 +0000, Tarun Sahu <tarunsahu@google.com> wrote:
> struct luo_session_ser currently embeds struct luo_file_set_ser directly
> by value. Embedding struct luo_file_set_ser couples the session layout's
> size and field offsets to struct luo_file_set_ser, preventing either
> structure from appending fields independently across kexec.
> 
> Convert struct luo_session_ser to hold a DECLARE_KHOSER_PTR pointer to
> struct luo_file_set_ser instead of embedding it by value. Reserve space
> for both structures in each session block-set entry, placing struct
> luo_file_set_ser immediately after struct luo_session_ser, and bump
> LUO_ABI_COMPATIBLE from luo-v5 to luo-v6.
> 
> [...]

Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>

-- 
Pasha

