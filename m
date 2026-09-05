Received: from mail-oi1-f170.google.com (mail-oi1-f170.google.com [209.85.167.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C43812D5408
	for <kvmarm@lists.linux.dev>; Sat,  5 Sep 2026 03:52:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788580375; cv=none; b=JMPnVoSwiMLgiHpVF3MxOryIBAok02O5ojJkk8g3QgIXk4A+MWx1EdydXvmkTW6jZV+jBTZs3YsHx0EtXaSS3WMqcc/C+LmuTl/DeHVW0IJafxEBi/1zE8ZI2BHFvUSZjRpq0dXHIBjA9kRy5ZCFdX1IcZAdoZX1z1AuVcfsIsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788580375; c=relaxed/simple;
	bh=TKvJdoBNTFok2MaEBjLNVasGV+4D9LYHCA0GP0GEJp0=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=Wk7hU2FV034Vqy2dNnd9Jk9h+5M51twAzl8X+i7IFD2ucwN9CtlkcAKG29pAELPFXMw998cTy/UiCBayBjwolsw6NZHT7vJmlDg1sO2BJlQLZvK1v4wnGezL96hh9W9Vdyg0JtXSSQlT6BQ8DAnElb/GdYjIL3NuUhWBLXZpyNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nDEcqlxa; arc=none smtp.client-ip=209.85.167.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nDEcqlxa"
Received: by mail-oi1-f170.google.com with SMTP id 5614622812f47-4b1fcd3b1a9so898076b6e.0
        for <kvmarm@lists.linux.dev>; Fri, 04 Sep 2026 20:52:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788580370; x=1789185170; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:subject:from
         :content-language:to:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=VD1ukRhdAuF2Z9Dx7wpw5NYE3cqbNhrpzdL3+1JpooA=;
        b=nDEcqlxaaPLmDkM/9anLdBpihcUjsRtv9y3ot9aYJhq5v+ckOIuso0iB7Y05h85tZb
         sgAwFFHuLzlTgbhHnmAaUmHEMxBdSvEeGEVe5hBsHdhIjWk4wYgR3RDaUD73fDoGuqe1
         jyOCXKRcV+c4wzlfxjcNoZCe0l5ExDKC7DXUNQmkt79iGK14B+oviDJPx9MeIBcjQ0ln
         G8GuRU4pwQL+V3HhmNVlSCKNXGg/18tTwoxcBn0+VmZrkkcW+IOZn+ElZiwvKjVoIsPs
         rRLt9nq0WLl81S1PmClNht2rdr4t48B4ikYl9My1xDWFuMKQ9Djywfw1WYkDRyusgYyH
         FSpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788580370; x=1789185170;
        h=content-transfer-encoding:content-type:subject:from
         :content-language:to:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VD1ukRhdAuF2Z9Dx7wpw5NYE3cqbNhrpzdL3+1JpooA=;
        b=dFO/FCAWK9sZFJCmUjsZ4fc+kpJ1tNqt6XnAxVgM1IXKOhOOPR/0lhexfK7PgAvsBm
         Je4YytIasZzwB1H1+8pES7ybLnl2W33ilB3g6ajgInXTPDnkQtxQXk/+rcTtTTlH7xxY
         U3guaq0T23hZKqLRMo96dS85GeDymOhHsg67Xi3tC+rh9d/r7bBFbVo7WQwwDf3no9wv
         qs+CwQ1u33TTJX2uexnVu1ADyF9SrK+3UbdZu8Zow0ZaSmRu4V/yLSK9f05j9TdPsz8Z
         pSoFq51lkdWJIYzUg0zwfaiWdAPeKyfLzVBitPDWTGyY90GK4ozBEMWiP7ER9lKnbwWc
         gcvg==
X-Gm-Message-State: AFuF++k+phtESO1oWl02RND+cesoV5bKS23vVkohg4y1YBKE0i+gs1Pl
	loyM8OZvkGUDuanwnvqfeaNoPxHB+U4Q1DbL4SoOfPV5NFOx24ZVT2kuCd5+KFUveRU=
X-Gm-Gg: AYBFou37oiOGvjS2EQa6WPfokDzyINWm292vh3u4vRsjRjKTjVyxOeDbLM7ZXS8yqC+
	upaPhb0hsvt0S4Rjt7y1kvOWsh/uqSZz9dJzNMoc6A0p1i6Fdkwucc74eBt1jT1vEqPL333i+ck
	+z7f8SoEQrrQg7k0sd40hcTjmnVMqyoNdsTb/Yt40/xiMmoVLB5OWQDOVfUrfIfx4nbgc15cnfz
	JIHmRn+s92sTdQfVZLGIDYE91kO+0r990mUC3wS6mV+Nj163wQ/7ToZJvEIOpmj6lCYJb/6A3cO
	p2dWsNn5y+aKVUqurZOCtpoxBb+NrWJK5I71AV3QCSJ8wud3TAjGWyRv9Q6NptZbCAMr0slDkPi
	9etKJfCdxBESEUwWX1D3+Nnx9ceV/+uX3UckErJ9WFoFKPe1X4/krMN5RmarxXqw6TxEepftRm2
	C6AYulWunWsWe8NI4kxBJWscw2oQPQCAtVU5sR/Hjum6kZiNx8dv6I2LXQgjcdZeFTOwaR5UpW9
	JNJ1YI+I/v5HttoALOIV6b+oQabZb/KVN55yS8BKjGfAPb336XP4Yc2PoqMxF1eVIBxgty9
X-Received: by 2002:a05:6808:6807:b0:4b9:e5fa:8a1d with SMTP id 5614622812f47-4b9e5fa8f23mr5175022b6e.34.1788580370285;
        Fri, 04 Sep 2026 20:52:50 -0700 (PDT)
Received: from [10.0.0.87] (c-98-227-49-116.hsd1.il.comcast.net. [98.227.49.116])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4b971c8ed6asm4484479b6e.17.2026.09.04.20.52.48
        for <kvmarm@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Sep 2026 20:52:49 -0700 (PDT)
Message-ID: <de8bfbe5-cc0c-4a0e-8d41-e461522385ce@gmail.com>
Date: Fri, 4 Sep 2026 22:52:49 -0500
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: kvmarm@lists.linux.dev
Content-Language: en-US
From: Normal Person <trontanner@gmail.com>
Subject: dumbass here, asking dumbass questions
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

hello i am sire dumbass the 3rd jr. this is the arm list right? because 
whenever i search up arm-msm i see something about arthritis and when i 
search up arm kvm i see something about a hypervisor


is there a mailing list for just like linux kernel arm? or is that just 
talked about in the normal lists?


i am still doing lfs so i apologize if this comes around as pure stupidity

