Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.35
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794331945;
	b=3/VBZVgQyORVeWyeJXV88GDnYTz6IJU9uul7B7TSQ4LN/xUSgF21MNJjWhduEMseKVnE
	 O6FcVkao5361GvHdJceOT2PgCZyMVg1Am4TZhaCs35VC77dr6jW0CH00GmkFSgtNN6xbP
	 kaQdePhKJCfLWkOROldYbX3XiFC+KRm2PSCKdqUMZXkF4vCZW2svXT7xf2FHSmebstxky
	 pFsPOcKOrhV6N7XMnyS1Y8o5knJ/KnrAF6co1QlpV6RdCMb1nW8Djow81o13LBDILlyoB
	 QbPa8aQJkY88hsotpqQD+vnUTPDUTFbUtKymtfU8fVGoBOzSF1lreZ40aujmiPYlpPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794331945;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=O/wNfj9zcVudY5TorfEHZYOP0zrjBm5k7fCeb1ImJL0=;
	b=eeZ9zUKyVYm16tYszxVPMbZiNsCm6SeVgFsXGgVgnWugQNXpk2HCvuFUySenVREDYOIL
	 PPRkDH8K+aWBbDmlOP9Cf1c/H+gk3d7Awbxq2EbH1vpw3dR4ctcfpAuHXsT8qQI+s6Zkg
	 hsIgBkAKIxf/fHmWU6iZ5IuySyzTHlysBUTTAHECVl92AHdBJN2SCoBy+X7Uj/EPn82j7
	 efBjSWZ/tUrz6VFrABqzmUycGCYgw4pfX4WwDdvNEL/oly/2NVLk5nMe1iR/aERRagBPj
	 jYU7LKFfIxxQxJG4fRUNIX3s/R16ozotXKflQ+CL+gm+8srgEN46d9k1CLHM+LDTwDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=XOv3DBb7;
	arc=none smtp.remote-ip=95.215.58.35
Received: from mta1.migadu.com (out-35.mta1.migadu.com [95.215.58.35])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 877EF60A2606
	for <kvmarm@lists.linux.dev>; Tue, 10 Nov 2026 17:32:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 877EF60A2606
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=XOv3DBb7
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=O/wNfj9zcVudY5TorfEHZYOP0zrjBm5k7fCeb1ImJL0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794331942; v=1; x=1794936742;
 b=XOv3DBb74Cf4TZgvyKAttfRt/iWRlihuvjHeqM/WSj6B6M69yj5UG33EYJJyf92KOiIq5zmm
 zluO6hTo3cfBuhXqOTm+HCzSdvRTblPGZgPBP232F5x8vlNJeFWFzcqnkeFfHUTh99EEDXjsWd2
 Ztp6eLryQCu/nCHDypEUzsFQ=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 21bab73f0acc2c13;
	Tue, 10 Nov 2026 17:32:22 +0000
X-Mizu-Trace-ID: 21bab73f0acc2c13
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-5c14bc5a743so12799e87.0
        for <kvmarm@lists.linux.dev>; Tue, 10 Nov 2026 09:32:18 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErHwuIbORi7cVlNIf7e9pYbUkHmb1X2nxB/4viX3ru3UXc2ZdS3k3ppvM/LZzvwbWle5lgDpo6Y=@lists.linux.dev
X-Gm-Message-State: APuU4Z9lhahg7tKnt+KDk6jkC7oNvNYh3MbydlarWRNEhF9bJ36ZNkRu
	W0hwu9mKJY/OCc2H2mcGzkJnOzMw+4PWX/P3VP0+fvuUzjM0uxmIor+XvlRPUKUqQ7nJ7WNUdIr
	TRovBoem8ySYlTun+w8zmeOHM4Ab5qYq7+h5gt5m1
X-Received: by 2002:a05:6512:1052:b0:5c0:7c6e:4559 with SMTP id
 2adb3069b0e04-5c157db2ba2mr166549e87.9.1794331937194; Tue, 10 Nov 2026
 09:32:17 -0800 (PST)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261110110724.3614412-1-fuad.tabba@linux.dev>
 <20261110110724.3614412-3-fuad.tabba@linux.dev> <avMoubwqgXbpflwM@gremlin>
 <CA+EHjTxT_9NghyLSZmOOi_oQboQw-g+6z9WxwaF=-7RdaGbMNw@mail.gmail.com> <avM9i8xWNZ2fU8_2@gremlin>
In-Reply-To: <avM9i8xWNZ2fU8_2@gremlin>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 10 Nov 2026 17:31:40 +0000
X-Gmail-Original-Message-ID: <CA+EHjTw-t85cJcZChnuEcTboe9FbLmvFXi+vn3os5N49R-z33Q@mail.gmail.com>
X-Gm-Features: AclHuK9X3Qq0RyJZlRjr_WD8VHNxqnjWuSAxxr9VQ80XC2fWGGeURk5VvSDZtkI
Message-ID: <CA+EHjTw-t85cJcZChnuEcTboe9FbLmvFXi+vn3os5N49R-z33Q@mail.gmail.com>
Subject: Re: [PATCH 2/2] KVM: selftests: Test KVM_PRE_FAULT_MEMORY against a
 full dirty ring
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev, 
	Wei-Lin Chang <weilin.chang@arm.com>, Will Deacon <will@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, 10 Nov 2026 15:57:37 +0000, "Lorenzo Stoakes (ARM)"
<ljs@kernel.org> wrote:
[...]
> > Yes, the acquire pairs with the smp_wmb() in kvm_dirty_ring_push()
> > ahead of the flag store, and the release with the smp_load_acquire()
> > in kvm_dirty_gfn_harvested(). dirty_log_test does the same.
>
> I know it's test code, but general kernel practice is to add a comment saying
> what memory barriers pair with so it's easier to track, could you add those for
> these?

Sure.

/fuad
