Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.180
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792664910;
	b=RKUr587XAgv0nYoCEEhIoDEfzRpe0KlPGxbL1sgOodG2qBA6y7y3MhdlWiXa4BYYndG7
	 xEu8/vkJZcVuf/Zm4/Y56JQILkdOaLbYBCYX8+Ci/E5oon84iyDJBmmp1urY19Qt2QhoM
	 rZd1BlK7Dj7vu1PeLgxreuks7QtWR0qhW/juf0lV+XuxBPx40UyOwEyBuP9JleVVgMdsf
	 0+6HIKnNUOKRnlSsZFE0MuvPzzykPTWWUWta6r+PV6q7LT1Q7xvuIA0M9M96Jp4kpTykL
	 iKQyfakmizNbumo9S+Jgwjwjw8rwuxHIiPJL35k7CkjGreVnjtTbR3O3TGovs9JDpTw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792664910;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=bi9/Yrj5aHhJwRPqGy69fpoodMHfZzxTRJdveUrp60k=;
	b=RnllZNLAjTQh46fqdAPk2wDX9yaDDMoVrM2NykVuwBhdXUo6Cksz5rKp13rrcu2XXW1C
	 ig+I7a5kVrc/mVMjsfgFnwRSFZ9aGdNI2JYb3klGM59Cz2NQvlEW1vA64IpRKPFE2mQ/R
	 Xmwqo3ePenHur8VqL6bFCCnLuEpqN4DbO6EojTW5H7CmB71hn6Kl6gpCDyBejOZtZpDsN
	 4RWvN063LePTLDySam2qvE7lriHXynTUUjo01HsMs4n73R4MTOZOE7Pgz+Jr08e9fEAcc
	 GIrcpM2v3mAFd88TOmHZBCytzH4la6/60unqN4ktd1GQlTpWl+aEsY5nio7e6irLiaA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linaro.org;
	spf=pass smtp.mailfrom=linaro.org;
	dkim=pass header.d=linaro.org header.i=@linaro.org header.a=rsa-sha256 header.s=google header.b=DbI7Zzh+;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.180
Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45891606A31A
	for <kvmarm@lists.linux.dev>; Thu, 22 Oct 2026 10:28:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 45891606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=linaro.org header.i=@linaro.org header.a=rsa-sha256 header.s=google header.b=DbI7Zzh+
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-8b118bea471so9222997b3.0
        for <kvmarm@lists.linux.dev>; Thu, 22 Oct 2026 03:28:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792664909; cv=none;
        d=google.com; s=arc-20260327;
        b=H3dDylU996kMBf/ND6bFUjZBnscttmR8UN0kCuJYXwRDjUkhjKEbsAAYjiU5DOhrcz
         O/pKJFxC8U+AC+L1D0grLS81qG0j1o9LRjBuTV6lRWAzeXkb8NcriKXilHAEqsn7DKn+
         dOar7GFlJ7u2kL8w5+I3nKAMKYw1Fw9X5i4Ill7LsPims+KU3RXWKAuuZt8iF7lyH3lw
         Vr1Wd3Uci+p2AD6Y17VQUKgASf/RRy0U+bxeriHPZwaEuWwSfqBimZPB/iPVpNUVYFd2
         ilkou7YspkDWNgGwKZDZDXzE3nxl/B+em1lyXpgo0PEoKwzPOQ6zdPAE1P3qCXOaNLIH
         LWOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=bi9/Yrj5aHhJwRPqGy69fpoodMHfZzxTRJdveUrp60k=;
        fh=zDdZHwwzvF5WRmEjlVyyVjjQRYJ7A67LtsZgevl2NZU=;
        b=ENYCMxZS73WfRgo9nkJ6oXrz2Id6Hngosq6e1p5YG/KbFKp2T6XzOPW07VzeNry6Dl
         KSedhoo7co8yfA7fvcxBAAeeX0vycx9IfrAhMXb6bWwOUWCFt12x57Hc3YJefrWMd73f
         G4k6gF43bGkdnOh3zpDMR1/XvfEd1lr9HipUT3qoYjMoW/oCMm2T58iya76D2UBgIoNG
         LsA6hKxBSo8XXSfU+9fxWAEerY6u1G5VpsS/gR9FwcNsDp1911kRZoES0/G6t+8oBORp
         v/+5x3JjQrk5PRMY/KrHmnC2C1k9ZKGcGWXpWtRlhKPDVO1KlD9yOqtxNXrvPyF6YmDN
         R/rg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1792664909; x=1793269709; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bi9/Yrj5aHhJwRPqGy69fpoodMHfZzxTRJdveUrp60k=;
        b=DbI7Zzh+ztzmk9n67m74zApA456RPtClKKrrNQ64qyWsrAgTaieqLy7r7PyaVzD9SZ
         pBEVrKBhpU2T7wRo3n3pirPhsLghesw37iagZ/BGDTaLEV/nDbkDFbMcuwBpkxT0X0hy
         mupvSmvTFNqbOW+MYARYn2mWnAOUaaUBBNqHDql24fppPyBkLNbXtq5Y/5GJouOzJcJh
         3JgFFc5WtDbUsVs680Qe4r7rjMBkcPdDRLzdvkc1T8VbhnM9KKh4NJ3u/yvl1ecMlrqP
         Q6+TqMz+YjmK6YvdlScNjcMUeWj8RKrM/W/hDLc8354DLjF8wH42OAwoFhxUA5YQkNAw
         XIKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792664909; x=1793269709;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=bi9/Yrj5aHhJwRPqGy69fpoodMHfZzxTRJdveUrp60k=;
        b=ZtdueqrkFbvNE/Hhl2Qn6lxKshuP99iHlLTFHjg3ObV7Hr9JZGEsjxzeG9OYQVqaZ6
         s87TXb5we5pKzctV7V3246b1SjejC/532NsHghcJPvUZ/gPdHNmBkFVD9z1r4B3oNfdr
         npP6eHzZt6nByy+SPypfYZwyb4rzHoPElXqHPmfIn7hn17L9fBjpQxWVkpstgwluhzlD
         6qlQwyMfc0LR5CmE5l6VBBmlWXah9caf+7CWDqdNnf9T2+gkUXUYSVZMuc1WYXrtuaUr
         IZCETKi+VlTe2JVZX25G6DoR9pXCNLIMweLiSD89KKfVUeOeY/4BwEi+zlglyDiFH+LO
         5qEA==
X-Forwarded-Encrypted: i=1; AKwUvBxtQ+XCze4+mK9OBFUhr1Ctm9a5PFMj1zJHiXoDsoA44LmW/sTvZRqwq6FGhJFnERgGs8aByoU=@lists.linux.dev
X-Gm-Message-State: AFq9FYI2dXrx91F2wqphFsjecrd0TLe56c76h9ACMpxze7NtcsUN8Y2M
	dKCmBR44SQkm2VzWLI0GBgLT1GFgmDNPFVa8C7gzeuJ83QR1jJhsP4pYpqZYmXrjsHs+Zw97ekz
	PkeP3MhdOC5lnjF928+hZ/eMi0bbnk2USb7Zv/x16Og==
X-Gm-Gg: AYBFou0q8U9yCeVo74g478BQPJQp4coTdpxUF6sfWrG69IDVyCfEI4PyfaYEyMAOlHy
	aIIj3jjgHTOqOR2O/E4K9PJjOiwUMTS6bgflXMc9tbffkZ5L8bqhgt58bpFAnuKqKYB6S0iL2t3
	vfD7mRMsnnoQUVcA+G+27f732B8RnHtPK13R/lC8r2NcnfagmOEaz+VoJ5raOaeHGh1hR4Y+fsb
	PfjzMITxH/NUmkFawRf7EgRq3oUUkrhxYnI+z8ZiVxUZQN441sv0gUOcZ/uAz+j6A3oca5Mdus9
	vsZfnXY3XmkNBiDjnIIlY27VIQo9h+djMym6jl8nu3o6WoYxWrlKq+f0BEA1HrQmynXWiCoH5Fg
	Gn4RImy9SXgVyymqothJ4CbADCxXyBfz434vWFPTXWUSjSzlRLKWbAvin2/lCC7d8WK+C2nckMI
	kZ7KpUS6up91anywEfa7gZxRGvw7pSAe8EOtv8+XzV4is=
X-Received: by 2002:a05:690c:e20c:10b0:8b0:6866:c55f with SMTP id
 00721157ae682-8b133f40fb6mr18913637b3.46.1792664909250; Thu, 22 Oct 2026
 03:28:29 -0700 (PDT)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261010133725.642498-1-eric.auger@redhat.com> <20261010133725.642498-2-eric.auger@redhat.com>
In-Reply-To: <20261010133725.642498-2-eric.auger@redhat.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Thu, 22 Oct 2026 11:28:17 +0100
X-Gm-Features: AclHuK_1uR0exODAeKMpAGKzedhGf6mf8KFDecCGvUHfOXUQRy65hEGCVhlibfM
Message-ID: <CAFEAcA-Ab8wkv0vedznXdzx2u2RopoRfr7SHnqt3Fr71yj=vBQ@mail.gmail.com>
Subject: Re: [PATCH v10 01/26] target/arm: Move REVIDR into isar.idregs[] storage
To: Eric Auger <eric.auger@redhat.com>
Cc: eric.auger.pro@gmail.com, qemu-devel@nongnu.org, qemu-arm@nongnu.org, 
	kvmarm@lists.linux.dev, shaju.abraham@nutanix.com, khushit.shah@nutanix.com, 
	yangjinqian1@huawei.com, cohuck@redhat.com, richard.henderson@linaro.org, 
	sebott@redhat.com, skolothumtho@nvidia.com, philmd@oss.qualcomm.com, 
	maz@kernel.org, oliver.upton@linux.dev, pbonzini@redhat.com, 
	armbru@redhat.com, berrange@redhat.com, abologna@redhat.com, 
	jdenemar@redhat.com
Content-Type: text/plain; charset="UTF-8"

On Sat, 10 Oct 2026 at 14:37, Eric Auger <eric.auger@redhat.com> wrote:
>
> Move REVIDR into the isar.idregs[] array as other ID registers.
> This will allow to overwrite it as others.
>
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> ---

Reviewed-by: Peter Maydell <peter.maydell@linaro.org>

thanks
-- PMM
