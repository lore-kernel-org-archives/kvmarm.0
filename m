Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794331792;
	b=cz9hzxenhz3IeZ4i+eBY3s+kuPnq30OZx5NnRiOLzfoHTLwcMWh45e9UaKkCWDpQUBC5
	 RlBTBUgbqP7fZJRt0C7JDDXI+7YxKWxyzYHooGUuZTkN7SuM8vZv76bAiVxOCuJ2WN4Xi
	 wa+nPgN8xaRIZf5mPJdqSenzS556h7f9vjJv9WHj51AMFLc5lFkWxZ/xcWd/Jy29HBVYF
	 9EpTLYVam6i6eVdIKCMy0qmzGU/1AVOg1iySguh/YgBB++V6suFN8mDld48E0e5B2XX4J
	 HIOrBd9DUV7CE1UflBNX4MozVyRDV90JkAfvJdg0BSO/O98Jkgn4Rvcge6V+PMkSs9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794331792;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=5wx+HPVDzMK2ZNFwmp4IvNdPd/griQf8bcKEGlkTO38=;
	b=dGnXH90AAs/DrZ/mP+XtDJ04rufLl/irujj8A5gTvwD2PKwU4kv7TQI9oR6KofjDZCGC
	 JJHWLAXiUYs8U0L3igzQ+jYiQOfZx16ncZbo1ZCuLn8YcA2NcHsS1ROCx+i5ddGuKzQeI
	 /b1QXBF9x4HP5kQQoLX62oKJl3E9NV0AT0NFfkJ3bgm5QZoNWLl8cToxsTj1KQtybjQO8
	 QuXBO76zlfXKTAoP0FMOiNy9kAWjA+8k+zE9np/TgXjwEvXhmk6+MHNyUMaqA8ZKvhwK+
	 9T0geziT53c3TcYx0YGO/uAxQYmiTnBvORh1hC7OGJZT5oYkozPWIqyu9Dq9yMD7eMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=DVxCaGom;
	arc=none smtp.remote-ip=91.218.175.181
Received: from mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A0EC606A323
	for <kvmarm@lists.linux.dev>; Tue, 10 Nov 2026 17:29:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0A0EC606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=DVxCaGom
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=xgvHwTGa+PgFPe0I//hfxTTphupF934nrFHnim+v1LA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794331788; v=1; x=1794936588;
 b=DVxCaGomepY3d20YObKqw7V3cyDs/TJthfjcv766H38S+BaEtfQ1FAMoeJMuEJZrEM+Dyhfv
 S/2OPxXXpQLUVFVTrRs8nms24kHcevp74b5UoVCaWrp+7QvyPwIjUHRPj7RF+q0Pw/UCLHieSXB
 ofErZtIT+FwmPEIa/GPUykAE=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 0def3d6b3725fb8d;
	Tue, 10 Nov 2026 17:29:48 +0000
X-Mizu-Trace-ID: 0def3d6b3725fb8d
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-5c144eb2f43so6201e87.1
        for <kvmarm@lists.linux.dev>; Tue, 10 Nov 2026 09:29:48 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErG8pB9Qss3fYuxLlR1ZWBUdBs29jxD0IvkwTJzWTs/SK0czg0GCBPf9mFvRMu7+swIXOgM5LT8=@lists.linux.dev
X-Gm-Message-State: APuU4Z9fDBt4/oryI8hd7uL05iuscdliVLXZGFwAarmife9H5xWtnljR
	EFaCGSef7JfXwfV12c7dsF2YhrvOKy8OoJ2zYtFjLcY5MNRtK1+KgNxI3oJludOfEUzMJP/hFmA
	IBBpCPI3YD2Kg1qbe6gryC6wxfkywIv8u0jO2SCJm
X-Received: by 2002:a05:6512:33cb:b0:5bf:f81a:f24e with SMTP id
 2adb3069b0e04-5c157dba643mr143671e87.10.1794331787336; Tue, 10 Nov 2026
 09:29:47 -0800 (PST)
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
 <CA+EHjTxT_9NghyLSZmOOi_oQboQw-g+6z9WxwaF=-7RdaGbMNw@mail.gmail.com> <avM9_7aWUDJSL3Lq@seanjc-mac.roam.internal>
In-Reply-To: <avM9_7aWUDJSL3Lq@seanjc-mac.roam.internal>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 10 Nov 2026 17:29:10 +0000
X-Gmail-Original-Message-ID: <CA+EHjTzS-=5kKVLD2tH7cvHJXK5UrMkHwHt43oGTz-LfgwnzEw@mail.gmail.com>
X-Gm-Features: AclHuK_8onLfxAou1vV3GX8Fp1YuNIw5KxweJ38CdU52leAU_A1H9EYmOqgJEWU
Message-ID: <CA+EHjTzS-=5kKVLD2tH7cvHJXK5UrMkHwHt43oGTz-LfgwnzEw@mail.gmail.com>
Subject: Re: [PATCH 2/2] KVM: selftests: Test KVM_PRE_FAULT_MEMORY against a
 full dirty ring
To: Sean Christopherson <seanjc@google.com>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev, 
	Wei-Lin Chang <weilin.chang@arm.com>, Will Deacon <will@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, 10 Nov 2026 15:53:35 +0000, Sean Christopherson
<seanjc@google.com> wrote:
[...]
> Before we effectively solidify the behavior, I think we should have an explicit
> discussion about the desired behavior of KVM_PRE_FAULT_MEMORY when dirty logging
> is enabled.  E.g. the only reason I kept the existing behavior in my auto-prefault
> series was because I couldn't think of a good reason to change it.  But we never
> made a concious decision in the first place, i.e. we never considered what would
> happen if prefaulting collided with dirty logging (as evidenced by this bug).

FWIW, I'd lean towards a pre-fault not dirtying the page. arm64 (with
a dirty bitmap) and riscv already map a read fault on a logged page
read-only.

Tried it on x86 by not mapping a prefetch writable in a logged slot,
so that the fast path logs the first write. That also changes async
#PF completion, so I don't think it's a stable fix.

The loop has to stop for as long as x86 logs, so should patch 1 stay
as the stable fix? The test skips when pre-faulting dirties no pages,
so it doesn't pin either behavior.

Cheers,
/fuad
