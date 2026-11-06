Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793975613;
	b=YZVnrj26QIKCOx8EB90mQ4Rpxs+OLsMSckPbpZGc2S4zY5eVNaJcohq6yfqtEH0z68DQ
	 pB9N10Ze6fSi27Kji4w88mQh/BjswUz8W8oFX2pW4N/Q8QnyOzwBMkCVAjhEMl7/f8oDF
	 YKIqO5/cf7xwDfPJkdOx+K0jb0Y+9F3tXYcsuy3uof4MoU69ngTdkp/8xpPv6cxQtIiEE
	 5GNYkvgsrmcha3hAiWAcDI1+oKhfYUqu95WXM+ZE0KVvif00/9pcOhrIZcso/FrYvflJ1
	 BtB2RXBuKnA5KCKAZdZZpy7nKM/W9zc4A1I7l++R9FFtBEUBO/j6Lb3v/0h3PWfoGrw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793975613;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=NLBSWvQdzP4LSJXmaAVuA3LXFwQgtJwF9yGVYnQFGaA=;
	b=dk0mRqVZL0unNFgUNqC48whN3BQOQ492E2DVyGBFtdreQZVaoVRUUQdHzmAzZqajfQLt
	 eQd+ChWPpSuDCeeHK4x2C73p5ZXi269WtKqnf7Nt/znoWtjAxQX867E+8FIK8UxptzZTK
	 7lP92VUsikeptPeMZXGr3JVCQydNQajbyotRPHP4VdgJ/RSW2hKezISUVaEvOelT61xG5
	 4cf5G3A39OR2fsTcvV14IciaFGcJX9kY2EzyQV+U0CR1ptbFS6wkjdRuBSpPBGdy3vjbX
	 T+G86l0fK+DTZ9HgFK35tSK8/g7oaWhhXGWXlVhCEcDAd56YShhSQqgfuMv04CBbwlA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=W2v7Ki6b;
	arc=none smtp.remote-ip=209.85.128.43
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E28F6606A32E
	for <kvmarm@lists.linux.dev>; Fri,  6 Nov 2026 14:33:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E28F6606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=W2v7Ki6b
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4a20bde60a0so5903655e9.3
        for <kvmarm@lists.linux.dev>; Fri, 06 Nov 2026 06:33:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793975611; x=1794580411; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=NLBSWvQdzP4LSJXmaAVuA3LXFwQgtJwF9yGVYnQFGaA=;
        b=W2v7Ki6bQDrYgknfk3QV/z29OaabYm8KIHV3SJGUGPJx6STkEtDCwNLiv9QncPhNAM
         /Q8SR5GrCGD6QpAZ1Xmv/hJBnjHK5NOdFMpC4chbrJjEuu6efbD+5YjtO/BuI1sJuNzP
         MJHk/8k4k5qwM6DIo6uS5yGLfqu5CA6WO+POEa+V/1GL9MscyUjg9i2T0svDPXQ1t4Q0
         eLo2Nf6i6+JlyzoOk3OA4WBYqCy+kH2CIkTDEe5nOM33hSSdI5ekyIgNpcqdal/y08K8
         t+O+462c1xR7S8Zb6On/S2muGkI6ff2cpfHxdse55woA7G5X4fPqUQaBXOGeeOEusDh3
         92lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793975611; x=1794580411;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NLBSWvQdzP4LSJXmaAVuA3LXFwQgtJwF9yGVYnQFGaA=;
        b=P5VH4eg2H655MsS4HXth+MpsZFtuH40TepSh8unXF7x0JM56wzxaWs+PNsah0W7v/X
         8ZNrL34Wamx1xk02VStP5FmBtNYNCBK/gkrZhTpklIzt2uYnoxv5iZdbkucKElm9tyTt
         P0aZOR27XgSKLSw1yf2q//4mtqtBgoqYjKbGKJ5rsWYR2W5DwdWp5/iOzS3rSbIV85CR
         OuXScfvfZCAbFyD8Vgr5tDu2buGNFkhklubU79YfAoM2KN3PKq4pm6UH88gzeibw/OGR
         SD2+L+nXcuoeMplLz5SZI5WFrl6VqA5V6R9zu4BSALXfZKmNP9sFZb4gS3ZfhlRL80ZX
         9inw==
X-Forwarded-Encrypted: i=1; AKwUvBx1xcaWdWnHLz/OioJ7j7y2CBzR/TG0+ZiM4g4bj1o2CLKZlt07mcCuq4IFALT/G2ZPV+EvaXA=@lists.linux.dev
X-Gm-Message-State: APuU4Z91RwpgEBXg0IFkdffi8wEJ/I5t3JwpFXUsgqLEhLuwOiA/3tny
	i5pgAGIPPMFr39n6zMx0eNEHI0dfGBAWmyKLq5qZJWNBNR1Q2FLy2XpOBAo3iv9VZw==
X-Gm-Gg: AYBFou1Z+d3p/edBzWBLWDysUFXfi8oGARPLYxhAQXRf3x0gm6XebaoTtbiKm7REaNt
	JBIvR2qBMHFIk53iPqGRtSWVNyC9t+uUXajIA5XJ8phSV3PCV36Jlhf1P+Q6N1VLyBU+9pYlQ/v
	4cGQWHYrSnTyLfW1BXWayMj74JMDu3WY0XiOS24ftcu56nh96oovT7YWYM9yx53hKlzcQINduSf
	H+MCFdti+ujk4QDvOymHxTWaD3TLqHa/2BSNEVBcbJjXZNrFWWF87lcbzcIQ5gJXd2KOmOeUVGX
	rcrT/KdnAZL+rbrGzjEvipquxI2J/PgPoj0tzqScSeT8QdDxG93ZpgYo4qZkv4OfkjBZIptPsB3
	B9B3/weO2aXXT8HxNuMLNpNzg+D0ckOn0OTgUe5p0C2T53m+dUwyMUxM1bDCgOywu3hYH+XrSp5
	dPiGkmfXVB2bPLEg8EEc8qgid2R4AQlxciqD5H7diyMQEr340jcgDSMgUZwYvCCAjdgURrbi/wg
	jMiCFpp2BbhSknYuCIkjiSBS1gSxuvrb7fQu/WIOBqFAaREqQzP0DRWUJY8InVD5Lspb0l3m5J0
	1/pziGlWX2myq+oNOwvinuMKZouN1HAIec90trfTpRfG0at4PZMlCFGbtvL6l6yO
X-Received: by 2002:a05:600c:46c8:b0:4a3:59c9:a744 with SMTP id 5b1f17b1804b1-4b6dd82aa22mr47981875e9.7.1793975610579;
        Fri, 06 Nov 2026 06:33:30 -0800 (PST)
Received: from google.com (0.182.34.34.bc.googleusercontent.com. [34.34.182.0])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b572bba0f3sm137145675e9.9.2026.11.06.06.33.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2026 06:33:29 -0800 (PST)
Date: Fri, 6 Nov 2026 14:33:26 +0000
From: Vincent Donnefort <vdonnefort@google.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: xuheng@cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Quentin Perret <qperret@google.com>, Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/3] KVM: arm64: Don't replace a valid hyp block
 mapping with a table
Message-ID: <au3lNp0vzK94uwap@google.com>
References: <20261105-hyp-pool-and-map-v2-0-44a6ca90190b@cs.columbia.edu>
 <20261105-hyp-pool-and-map-v2-3-44a6ca90190b@cs.columbia.edu>
 <CA+EHjTx-X_2DaO6Yt-AHsP55SFWjz_EYxEr-TB9WSN-ZT+d3FQ@mail.gmail.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTx-X_2DaO6Yt-AHsP55SFWjz_EYxEr-TB9WSN-ZT+d3FQ@mail.gmail.com>

On Fri, Nov 06, 2026 at 12:03:29PM +0000, Fuad Tabba wrote:
> Hi Xuheng,
> 
> On Thu, 05 Nov 2026 22:59:50 +0000, Xuheng Li <xuheng@cs.columbia.edu> wrote:
> [...]
> > No in-tree caller maps into an existing hyp block mapping today, so this
> > cannot be triggered in mainline.  Fail such a request with -EEXIST
> > instead, so that a future caller gets an error rather than silently
> > losing the rest of the block.
> 
> Could you mention in the message that the WARN_ON() is fatal at EL2,
> so a caller there gets a hyp panic rather than -EEXIST?
> kvm_pgtable_hyp_map() is already documented as rejecting such a
> mapping "with an error and a WARN()", which is a better reason than a
> future caller.
> 
> Also, please don't respin series so fast. Give us time to digest the
> series first :)
> 
> Cheers,
> /fuad
>

Actually, why making it fatal? All callers of kvm_pgtable_hyp_map() are checking
for the returned error.

-- 
Vincent
