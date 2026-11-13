Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.70
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794577657;
	b=Zn38WjqGHVNzGfAQ6eUVsgm73Og7j90vu4NiYA/80cTwWd1IOl86AVcPiuGcMcKCjNvC
	 nYJSQrzOzg4sRmpx/BZ6U0S0eRjMPQNm82bPdKFV30XAUvN58zDMK7MF9vPPom9fsh8pP
	 6GG9QT2/7h/si7eVn01qaIl8kQKU8MYRYLjJMHt0Yuny+0WGbQkfhNtqpAEKncsPx3Low
	 2La5OU7fQNK1nLJQpAB3/aCAaCECrLuzuCHbU/57JDPtCsa2kRkzc4UsZUTNCXWkVR8Lt
	 t2NX7aus+OFzGSgKf/Tb3RBJNSMMs5lxPbd0Oyti2rYcW+BpYXJdAOvj5caxkaPhgFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794577657;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=Uh3RNZiwQ8OEliQwz60GaSWCgjS92PjWqF45e5QPMWE=;
	b=N9R3u9P3MSC+qMuiFPTRZ2ug+gxungxbNXIJRwGthzXf4nTm1wsfHGVTqJm6DJg3ii1/
	 LjQHZGC4s2o6oJ/qDyMEzyH5KSD6g+Sdf62ll0+T/Hn/S/d/svvhcA1HQd9GnIbw9+mVx
	 fnuldwHq9dNjiF7xL2ozsldNHZLyIHhnC9Dxpd6JJmBiMwwrFEE2sEu7lW7/mb5j+ooGE
	 /JGMylWsS9J4u1KxWU2wa+rSiiTbvsXR9ko0t+k17WmGof9bKG7domYSEOp5VCAZwVOlt
	 ZkkQ43tGhaQ9Id6SLETJ2igBvLxZwBNFk9kteRUrfEkPG0CeT90WYpGy4mnbJW9Omwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=oOS67t90;
	arc=none smtp.remote-ip=209.85.216.70
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 166B5606A335
	for <kvmarm@lists.linux.dev>; Fri, 13 Nov 2026 13:47:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 166B5606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=oOS67t90
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-3ad53f538d2so784391a91.3
        for <kvmarm@lists.linux.dev>; Fri, 13 Nov 2026 05:47:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794577656; x=1795182456; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Uh3RNZiwQ8OEliQwz60GaSWCgjS92PjWqF45e5QPMWE=;
        b=oOS67t906gXfKvpUijcB8CoSO/n5VRdac5dH4Vyq5G5GxXFCFNOZ8hvmoyJvtKU8rj
         n8u5uNmI4g+c+IK5To9okG3SNZAukMo6ZuUP5uJJtmkLGE0qw0XrYxk2s/dnNRhLmz/1
         m+vQcWECZcHswNeEir1XqpvlwNP1Riv4sNY5I5iLrvH6QM7KlM1t5RWOV0bhIeCuPejv
         hJGUJbf0frhkVQ1cTtCM1JOruin+SAzVKW6l7YblM1TIeutEbKp3Tt6C3lZ35IKRA7il
         O+IhVRLI9HJW0ioacU28udzW0I6PJvhsOZSdFM4LBUbhjPCIhrnITkHIyowGBiVpcTXK
         x4dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794577656; x=1795182456;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Uh3RNZiwQ8OEliQwz60GaSWCgjS92PjWqF45e5QPMWE=;
        b=dU6Mc5GuJct6quWWdsfRU6pHahfIsYWGRRnxy3RE4/BYMTDfDk8y6CKp9G+G8mX72f
         vzQrvv80zIjlG5PkDj5dexiOuJJfpoOTOLZh+4bEdce5uhFqFy4vB5AFE5Aoba24L4zE
         eedeV2wiGF3zum8QyueBrRAgvIBrvCGuqQl05aHpxGyA99/oqCrFCGYKbNPY22h193x6
         BPE6vc7oi5XDTsCiHgr1mPZx1ElcmQGJgBYGJXJe1kHGJytBNbMWV3iulVDzqOGkZKaL
         3RS+jj+/gLr1JnkkgxtI9mVg+UAqIS6OMyHNoYLut1zvhte9Y9HtknkekJq+I+VQ0UJM
         QHsg==
X-Forwarded-Encrypted: i=1; AL+hErHX3vkkfx6CXFP5Mdoy7pUzRkP8WudxcN7I8+50hx5NVaeG9J/P+8lh+UXFSNj3Q7Z2nI0yBnA=@lists.linux.dev
X-Gm-Message-State: APuU4Z/QFVnPBFKQoRH6a4K0+E3LmCGSisZIb+Bn9Jhj49/+AAZVUk6H
	Cji1/Ktq5ple1MxEn71VCQ227YNF/MX+HJ4QPj01mElkw/GStyj0HR9mJ771tYthp+5CGHhJ4LM
	rH2lkDg==
X-Received: from pjbgc19.prod.google.com ([2002:a17:90b:3113:b0:3b0:a379:b383])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4a50:b0:3a8:c0cd:57f9
 with SMTP id 98e67ed59e1d1-3b1b0a0db23mr2345964a91.25.1794577656089; Fri, 13
 Nov 2026 05:47:36 -0800 (PST)
Date: Fri, 13 Nov 2026 05:46:14 -0800
In-Reply-To: <20260922071945.693714-1-fuad.tabba@linux.dev>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20260922071945.693714-1-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.56.1.703.gf848ed807c-goog
Message-ID: <179441838666.82439.8379969006436543719.b4-ty@b4>
Subject: Re: [PATCH v2 0/2] KVM: selftests: Fix incremental build dependencies
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>, Fuad Tabba <fuad.tabba@linux.dev>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	"=?UTF-8?q?Michal=20Koutn=C3=BD?=" <mkoutny@suse.com>, James Houghton <jthoughton@google.com>, Will Deacon <will@kernel.org>, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev, cgroups@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Tue, 22 Sep 2026 08:19:43 +0100, Fuad Tabba wrote:
> Changes since v1 [1]:
>   - Use FORCE for the sysreg header rule instead of duplicating the
>     generator's inputs. (Oliver)
>   - Added patch 2, the same class of bug in libcgroup.mk, found while
>     testing patch 1.
> 
> Two fixes for Makefile rules that name a directory where a file's mtime
> is what matters. The first is arm64-only: the sysreg header isn't
> regenerated on an incremental build when the sysreg table changes. The
> second is arch-independent: cgroup_util.o recompiles, and every test
> relinks, on the run after any rebuild in lib/. The two patches are
> independent.
> 
> [...]

Applied patch 1 to kvm-x86 fixes, thanks!

[1/2] KVM: selftests: Fix arm64 sysreg header dependencies
      https://github.com/kvm-x86/linux/commit/b2ddd6af0646

--
https://github.com/kvm-x86/linux/tree/next
