Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.166
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795463268;
	b=wJEUDml8QHGi1pcxJqzk1hII0zDxlrI9re33SWNaqyDjDINrF48gRePqLyYS3qvmiX9O
	 cUjT2kd7zKhFbmW7U27KGuvCZCSKhbm8SAW5gmrt+2vAWbg+PreNUy+VQX1ao6PqeOe+K
	 MNaFViZETCfoQXQjFUbtvSnYLe7p0ReJx7Q9f7DZa14M/cAaSg8HH4MfPDEvF5S047Hiy
	 CwMH832YoMvbRNSxpdq3+BrXxE7pdO0hM9nwnuzp1xIReHuktpcG1miMRDpsF4kxWArI6
	 oGZLVhfAOd4JVUa0igKAhD519SvGHj96Ig8eet7ViUPoAzt4KZ6g8ZnF9FwvUChtPrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795463268;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=IgLGsvO6I1cVesMXGOLiV/+5WDdxgMcaxBy6FOWw03c=;
	b=Ur1Wl/86uBr9avAHwiTm5FB4xmTFke7H/zVRG6diBLEP5bvKKk3L/rl9kMswB10BEiZa
	 1R6LBKoldzjEFphbiKaqJGj91PAtlk0RAxSiIAv1frtZPzSHydEXvlkGWC1eWeU7nR6cD
	 QnFrZ78Y2kC7l4CYKHJqIvO52B4wK0Bw4YQBaeZMzApAdXQhFkQSFFfnw5Ue4nyNiY+oZ
	 XXXtb7E1Af51hyjETH2PpMWO+ltIo2KEDg+os9XXWD+T3D1YkqJa9MiM92YnD1PooRy/g
	 8PiRjBLmY/h82+aP50Sk60baTGjYkPOuQ163d6xqUAG5PFIPdSywFSXJj2kNocdlBEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=lA2E68WD;
	arc=none smtp.remote-ip=91.218.175.166
Received: from mta0.migadu.com (out-166.mta0.migadu.com [91.218.175.166])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F284606A31F
	for <kvmarm@lists.linux.dev>; Mon, 23 Nov 2026 19:47:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1F284606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=lA2E68WD
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=IgLGsvO6I1cVesMXGOLiV/+5WDdxgMcaxBy6FOWw03c=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795463264; v=1; x=1796068064;
 b=lA2E68WD0WkftNbJ4nxgKaxfCY1G5+C4xwpXNjo6LI4u/syjbk8Qs7DNWP20j/HSexvjmy6l
 uoAg154xs25ylLIhW5GKTTKukSyGfNfSpF05/XHkD5HB+n08eQG9WmueYvgG1+6tAxq2w1cZs8h
 vY8I63aJQ52Fd6A8uHLflH1k=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 6740a640e4fe41c5;
	Mon, 23 Nov 2026 19:47:44 +0000
X-Mizu-Trace-ID: 6740a640e4fe41c5
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-5c14bc5a743so15857e87.0
        for <kvmarm@lists.linux.dev>; Mon, 23 Nov 2026 11:47:44 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErEwuorbsMuGNzwraXRn4FkrBsEE8l13/QxFsShUfj252CcHvmGSW1LAjpVX/JrBSYtFHKc3CzY=@lists.linux.dev
X-Gm-Message-State: APuU4Z/+R+RCU5HutveecixJydO8E24kCqOC4Xnkzg8XSNp9V6tkaod3
	gWjMiw1qJ7IAH4IVfQE2bP9GbBC1aqG1G0mPCD0VZYwFyh8UgT2MW21bUsS1OJ5T2bc5M7iJFe5
	UL3bIsjTEsLKENDfForZy+zXiS2iSnbdYdyC5aTxE
X-Received: by 2002:a05:6512:2342:b0:5c1:56f6:2f50 with SMTP id
 2adb3069b0e04-5c21234bb6bmr259897e87.1.1795463263390; Mon, 23 Nov 2026
 11:47:43 -0800 (PST)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261117174403.58762-1-vdonnefort@google.com> <20261117174403.58762-12-vdonnefort@google.com>
In-Reply-To: <20261117174403.58762-12-vdonnefort@google.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Mon, 23 Nov 2026 19:47:06 +0000
X-Gmail-Original-Message-ID: <CA+EHjTzXp-id_CFECB+X-F7GZ9etswCVknWbZzC=euZk=1psSg@mail.gmail.com>
X-Gm-Features: Aa3M54rgmBRXFm63EaKcGRVndPx-0D9msphFQcyS8e9jJT3_VFzFGgPwCV7sANA
Message-ID: <CA+EHjTzXp-id_CFECB+X-F7GZ9etswCVknWbZzC=euZk=1psSg@mail.gmail.com>
Subject: Re: [PATCH v4 11/23] KVM: arm64: Add a range to __pkvm_guest_share_host()
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, 
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, kernel-team@android.com, 
	qperret@google.com, weilin.chang@arm.com
Content-Type: text/plain; charset="UTF-8"

Hi Vincent,

On Tue, 17 Nov 2026 17:43:50 +0000, Vincent Donnefort
<vdonnefort@google.com> wrote:
> In preparation for supporting stage-2 huge mappings for protected VMs,
> add a nr_pages argument to the __pkvm_guest_share_host() hypercall. This
> range supports only two values: 1 or PMD_SIZE / PAGE_SIZE (that is 512
> on a 4K-pages system).

__pkvm_guest_share_host() is a function, not a hypercall. Also, the
MEM_SHARE hypercall still passes one page.

Cheers,
/fuad
