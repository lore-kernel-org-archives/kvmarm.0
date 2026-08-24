Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35DE03EFFC6
	for <kvmarm@lists.linux.dev>; Mon, 24 Aug 2026 09:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787562321; cv=none; b=E9j7N39LaCr6g5THdfJtRWKIvYu1PS8lBdAScKJS2gHzsUjDQEyuIIYrwLCm+scYHOtWKVDzfLsKL2E/5qoktF+s2MKs6DlY6o63xANriCJzbprNLjLj/Okt0Ib03ZJ57ju+ALv3pMqfRzta1Qlzv5ax0xo5JCDYhZT4Mw4Mihs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787562321; c=relaxed/simple;
	bh=yxdOwrSsTMciXo/tP789U3pWWmqLPlJh5w2RmaTvaj0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OsPQUvjfmxMtQyPgoYIdCPineeylofNwZQOKbKXMoW7KHgNctVC9dKEW/mCbOBzStWFRGWcIRZcHzIcaOZvJi2t+frCYHqvuPc2+3cgHkazGf8HAbpo99lDl5+An9L4z6yEAtzO5XWe1K3HTp9FsU/ZfeJWmdvC+iS4YwcJc3MU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wWSISkaC; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wWSISkaC"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6a1f8757b4eso12374a12.0
        for <kvmarm@lists.linux.dev>; Mon, 24 Aug 2026 02:05:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787562317; x=1788167117; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0oE7bRBEKrds8LRc7kKAKPBdAOrOs9h0iRGg0/2yeYk=;
        b=wWSISkaCQeM7z4YrAOAk3AnOo+++UMw9pLzbxZzH5CBBqCi9WpMUWFW4hZosgClsVW
         8qcNiZVljZvuDzfv/ys67KlngRENYl3m7mWKWHCXq68ZTBumZpMiReAMlFQ3hyjFlGbN
         R8Nx+8c7wwiYrtTzePZoJPqW383iVVHV8Y7AOy+cV6cwgHbOaDBzKSUCdEL6hg1TYKY5
         W4H2twVA7e+j/R/BmbEPG3tnVO467L0G7WNIcvpwT7rzGN6gE8n+0ktAWESWr8UmjT6L
         sRjgUIU8Uc1Esb1Tr8CtU0MG4rDGTbe+nXbAU137ABMWWyaANIA27n8S+gldsnxAqlXz
         B4YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787562317; x=1788167117;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0oE7bRBEKrds8LRc7kKAKPBdAOrOs9h0iRGg0/2yeYk=;
        b=Z02DHrWO1ui0HbrLL4ckoCeXwjEyjWpiyZGWwvEyyTEz1MQUQmdkcIDibIMUG8LXUp
         9Ocg8vKQlq2X7TLzQopGQk2RI/Sz1txH7zndmln3MWL5ji/595kNHldsy66nupe5lsao
         WV9bzjOYUvQQXgl+InwZ4ROHVz7jzhkMgvJa37+xqVh9H7GNI81/M2ACUzvDMvY4Yzk2
         9qyDxx1lMQrn0X9Sx3j+lWN5VEZv7Vf2jCt7MUR8Gh56nqWGiXtg8CdwE0GwGiV/JinZ
         ASdp5T99ROB4XB7vnuF61ifbf+OlWmqfOPIsWBYij0ddwWEu7eWrs1R4Xzjb/Vc36zlk
         mcEA==
X-Forwarded-Encrypted: i=1; AHgh+Ro9B1nIzNOeANgD6ypfxXNI8GHUrUM7JvSK5BGE/LOfyVXDS1HnaZSyU8bZtwUL3Y/ENFIq484=@lists.linux.dev
X-Gm-Message-State: AFuF++nHA0TIaPu5ujsxrOh/WcUGhVATueMW7+N2GfJzTGKkhY7ModXB
	62VRvH7bfbtDDCwLGbVflz6Wb7nq2lv4QBtRk/1xCw/S89vMQoEPEraHBU6sPinrXQ==
X-Gm-Gg: AR+sD11s8qvG0GrwVUNSpmQC3WcJZlpnNnGb+px74pM5kyTrXL6yvH9nCwGFtRxKh+R
	ANaR8Kb17Vkn7tlEt+ktNXXJ7fbzu1VTLH2eT7nR+bWrC3QwJaQ8YBeKKno6k2M1TozisBAiduI
	vIP0xpKp0oizE5CCSDIGYfVLVOCH65bnPrvFFJaQjEzXJghnON+PB5FDd6+c1PNajehgkhguwFm
	+DIEhUw3FFGeGw2RcfjywxUROK/wfS2CidtI58VT1lNxXFlroBG7hWB+IBTrCLoAIyrTUnO9IgC
	x0JpV7WtX3/nYTL1BC7Eo5KkZGpOh2P6X3sWsM1cE/oizQrl201wPTB7yhjNcXP1vXr78utE/Dl
	cy+Jf5GVMIj6dgktqY+k6FStdw0NP4Fj+D8RP73DOi+D5unuIx7y/MD6iuiypRYFXeLWqbzI+Gf
	ZLBeTpsdpONkr1mFvqZ54S2TP64UKztrY/eh+OGg0ZPG4GS++lA/rTZWN6qHCRYFS66Dpyfvvc6
	R6Zd3Fph8F/MS3uOY4I2LZOFEoiHgkt
X-Received: by 2002:a05:6402:a50d:20b0:672:117e:55d4 with SMTP id 4fb4d7f45d1cf-6a582669e18mr65014a12.0.1787562316885;
        Mon, 24 Aug 2026 02:05:16 -0700 (PDT)
Received: from google.com (63.235.189.35.bc.googleusercontent.com. [35.189.235.63])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2496738e8bsm1063366966b.44.2026.08.24.02.05.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 02:05:16 -0700 (PDT)
Date: Mon, 24 Aug 2026 09:05:12 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Mankyum Kim <mankyum.kim@samsung.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Will Deacon <will@kernel.org>, Fuad Tabba <fuad.tabba@linux.dev>,
	Andrew Walbran <qwandor@google.com>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Re: [PATCH] KVM: arm64: Allow smaller FF-A RX/TX buffers
Message-ID: <aowJSDF7SpEHD7FW@google.com>
References: <aocAODVhayfmy26M@google.com>
 <20260820-master-v1-1-ea602b6d3860@samsung.com>
 <CGME20260820132522epcas2p329199ce99df0337540735564d881116a@epcms2p8>
 <20260824005345epcms2p8db2a7aad5598b624129873d1a1abf8ff@epcms2p8>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260824005345epcms2p8db2a7aad5598b624129873d1a1abf8ff@epcms2p8>

>On Mon, Aug 24, 2026 at 09:53:45AM +0900, Mankyum Kim wrote:

Hello,

>Hi Sebastian,
>
>
>
>Thanks for the feedback. I took another look at the SPMC capability
>reporting and found an important detail that I missed in v1.
>
>
>
>With FF-A, the SPMC in this configuration advertises both the minimum
>and maximum RX/TX buffer sizes as 4K. `hyp_ffa_post_init()` currently
>only considers the minimum size and ignores the maximum.
>
(making it readable as the reply was sent in html format)

The max size discovery has been added from FF-A 1.2. Old SPMCs with <
1.2 will not have it.

>
>
>I agree that the host-facing FFA_FEATURES should report pKVM's RX/TX
>requirement, as you suggested. That would keep the host/pKVM mapping at
>the host page granularity and also avoid the partial-page sharing issue
>Marc pointed out.
>
>
>
>However, with a 16K host/pKVM, the host would then request:
>
>
>
>```
>
>FFA_RXTX_MAP(..., page-count=4)
>
>```
>
>
>
>and the current `ffa_map_hyp_buffers(npages)` would forward the same
>page count to the SPMC. This SPMC advertises a maximum RX/TX buffer size
>of 4K, so the 16K mapping is rejected.
>

Right, I see what you mean. In this case we would have to :

- keep track in a variable for the size of the hyp mailbox buffer
  (pkvm_ffa_bufsz) let's say

- make hyp_ffa_post_init aware of the max RX/TX discovered size if we
  are running with FF-A >= 1.2

  if max_rxtx_sz < PAGE_SIZE * KVM_FFA_MBOX_NR_PAGES:
  	pkvm_ffa_bufsz = max_rxtx_sz;

- if we are running with FF-A < 1.2:
	pkvm_ffa_bufsz = min_rxtx_sz

- update the code for the host-facing FFA_FEATURES to report
  pkvm_ffa_bufsz when queried from host and make sure we use that
  instead of the paths that use KVM_FFA_MBOX_NR_PAGES

>
>
>It therefore looks like supporting this configuration would require
>separating the host-facing RX/TX size from the SPMC-facing RX/TX size. I
>also noticed that several paths currently use `KVM_FFA_MBOX_NR_PAGES *
>PAGE_SIZE` as the capacity of the hyp buffers, so simply mapping the hyp
>buffers with a page count of one doesn't seem sufficient.
>
>
>
>I'll drop the approach taken in v1.
>
>
>
>Does this match your understanding? In particular, do you think your
>configurable mailbox work could be extended to support different
>host-facing and SPMC-facing RX/TX sizes, or would you handle that
>separately?
>
>
>
>Thanks,
>
>Mankyum

Thanks,
Sebastian
