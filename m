Received: from mta0.migadu.com (out-98.mta0.migadu.com [91.218.175.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 838FD3EDE63
	for <kvmarm@lists.linux.dev>; Thu, 24 Sep 2026 16:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790266537; cv=none; b=MvbCmA+UYCfrE8nnnPqeiewavm7QSTNqEIRoZ4RnIEs999cugd5YsCtmiF5a1bcftUrIQ2soTQ4US/ntWmyEiTZbnlXLKQO4fx82eZ+45d0SH9qZxPoQweijLwbZB5rwCt2cmQkRQ4EYuafY0Xlg5pck+OT5xl1hxknputHPchg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790266537; c=relaxed/simple;
	bh=UX7EgEFsk5EAatKOOTUC+al3WpafligDGOXSJOLt4Hw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rBMczlKOh3I40bAuVfw+2Zga+b1t7yc05VBTKJMwXFXmCiIfpWLlJ++wGxWtKbDG3wBXskGVWwAnDgdKj9L/oTXkwOJw7vET/jEFSBGMkV6C2mVkmybYEaO6NfDfsoIHk1oEq9Db8ntQHxcgmyjU95zGjKYl3xmDgPsjFYeyxjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xtK/V5rE; arc=none smtp.client-ip=91.218.175.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xtK/V5rE"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=UX7EgEFsk5EAatKOOTUC+al3WpafligDGOXSJOLt4Hw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790266533; v=1; x=1790871333;
 b=xtK/V5rE0nZEKEt+pCWKgoJP/ZBaBz1M56WR8vBqtEX2t0flfX9Gze/fwklHbU6naQynTFva
 pJvYT9QKBob8K4OrL8mD9/aoAtFwNqw8CaDrEypAWPl1I+IqRbWBNSPEsQl7aMd1xvARc+AVrKv
 ixkR9eIWGm5Ad3fbBb5PoAuE=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 7284cb3c19d4e126;
	Thu, 24 Sep 2026 16:15:33 +0000
X-Mizu-Trace-ID: 7284cb3c19d4e126
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-5b83c1421ecso9023e87.1
        for <kvmarm@lists.linux.dev>; Thu, 24 Sep 2026 09:15:31 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwqCkC6J0zOw7lmePVAn0vwhv+JngdAaylrLHZK7f2wVWzvoaWFMH8I9zmFeDntkr4J9uXKLJg=@lists.linux.dev
X-Gm-Message-State: AFuF++kMVtWTQdbtFXpbN4ZL0tfDujJqzKKoZaYyfp+v53sK9WMFcbw2
	nCyrQ3KcndJVUT3TMX7ivBkr/NPbl1KHnrMAKUOLwgzgDr/u5g5HMsIh/nni237CcL/2pbKrx9S
	WvajD2tbT1k/8//PQGWzWCI5zWB9oWnYZ+Xme61rq
X-Received: by 2002:a05:6512:32c9:b0:5b8:d442:fdc8 with SMTP id
 2adb3069b0e04-5b8de5d9325mr177197e87.11.1790266530330; Thu, 24 Sep 2026
 09:15:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260924095154.807726-1-vdonnefort@google.com>
In-Reply-To: <20260924095154.807726-1-vdonnefort@google.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Thu, 24 Sep 2026 17:14:54 +0100
X-Gmail-Original-Message-ID: <CA+EHjTzOZi-N4XCRKGBKqa2=PJZRyVskooGgT4HWAwErUTMROA@mail.gmail.com>
X-Gm-Features: AclHuK_tH6CK7thhQNxrfh8ab79-Xf84DjyiuvCMf80g1V6Cn9QTyhYpfN_0fio
Message-ID: <CA+EHjTzOZi-N4XCRKGBKqa2=PJZRyVskooGgT4HWAwErUTMROA@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: Remove PAGE_SIZE alignment for hyp event ELF sections
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, 
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, kernel-team@android.com
Content-Type: text/plain; charset="UTF-8"

Hi Vincent,

On Thu, 24 Sep 2026 10:51:54 +0100, Vincent Donnefort
<vdonnefort@google.com> wrote:
> .hyp.event_ids is mapped as part of .hyp.rodata. As a consequence this
> section does not need any page-alignment. Remove it to save a page worth
> of memory.
>
> Fixes: 0a90fbc8a170 ("KVM: arm64: Add event support to the nVHE/pKVM hyp and trace remote")

Could you either drop the Fixes: tag or say in the message what goes
wrong without this patch? As it stands the message describes a
one-page saving, and the tag makes it a candidate for stable.

With that:
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>

Tested with the hypervisor remote ftrace selftests, in pKVM and in nVHE:
Tested-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad
