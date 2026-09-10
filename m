Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB3EF3C3C0F
	for <kvmarm@lists.linux.dev>; Thu, 10 Sep 2026 06:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789022334; cv=none; b=bMD/UGeXW1jfeU9sZimznwFy+YG8q+MyfCir7j4bF5LH3djwt+npwT8cafDKwj/1YXoaHRSocH95qPHdPK/oB2R2+PX0BZRw3ps7/ue2xfsqTiXjCv2l9ucDNfgTgii5P/KropW75mGL002f5WCA6ovcnManrFfNBzxAlWLEdeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789022334; c=relaxed/simple;
	bh=TP/7+E4rrU+pDYrVqTFosm4KeNM9JoqKXMfQYJNgxAE=;
	h=From:To:Cc:Subject:In-Reply-To:Date:Message-ID:References; b=j5C9ddthTrlAOImwEt9Y9cgoKgWjoReozngPS+T0Gy0qFUkcTV4vXcGi6mvj4m+cF0KC2fVyaBWhM+zq55+5mWdu4HtcYbicnBkSxmQ7pwRra9Hp0BcBEsNZ48vjXARxhhRfRM5txz52zrEqRqreYWyisYkrjngpsxq/0vCHY1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=q9eRCiSR; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="q9eRCiSR"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-398b3d66515so6895346a91.0
        for <kvmarm@lists.linux.dev>; Wed, 09 Sep 2026 23:38:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789022332; x=1789627132; darn=lists.linux.dev;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=TP/7+E4rrU+pDYrVqTFosm4KeNM9JoqKXMfQYJNgxAE=;
        b=q9eRCiSRfxIQVl9pX7KDjwiJQ1+/OG9r5mWhSR2Tv0Svp6vRXUQf+xsXwq5ecDiIiC
         hv9mGnuXXHSDN7OojfWzVCrXATuG+T9M69GTYNNnFnRc/dMsKOg0n8xpQVq3h5/V6zED
         NwiHOKZDFHidgUiVdX/QXSbbZijXUt2cbtZ8EU1y+YzdxlvfWZxYmpLV20xzANqV+Kvy
         BBjVkspBOyNXNguezKq9Pfdiy+oYI9EPrjjdSqICIgR5hEFpRu/M7BwkBf+E/4JyLqRB
         R2Wp+m2sQ7tXoA8IbCKA6fh7BUPn8dbzsmvHtIwEhLHmHIBj9Pvj63ccy//JHbPcDnG5
         W2Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789022332; x=1789627132;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TP/7+E4rrU+pDYrVqTFosm4KeNM9JoqKXMfQYJNgxAE=;
        b=Wj2Lw+G7Sd3XByWnygz/bDCbirPx1FPvLolmvtFJSjVO9sYKvfRC72BDenSsCaVi8F
         w3jDvjkQJxQyJEoFDXaDD72KM1HQVLnuE9FPsK3iiq6abuEb84+d+fcN2rJb/OR+Ka/f
         wBgTQnrXCZUt0Ez+NouIbvfigyyabXvQOBy5orIG4HO2nqKqWQHlGJcH77kxxIVAPCu9
         0S61UhFGtivxW7f+uaAEACM3zxSUgb+4rFFWgDjBa+xnKK96IIWi0c12PynSE+AmUpVF
         x68WpllNwdFzIe7R0c/3TnwLJhEmNUnYPJWDKafQ3w6Jk8WwTbpc15xbwrQrG0EQedK9
         PdBg==
X-Forwarded-Encrypted: i=1; AKwUvByzBKgH556RXo42JcrD9wi4fHA0mtVnGc+tKpihpRudWjIMWGb+/hxxYUooPUXtgnE8LZgX7Cw=@lists.linux.dev
X-Gm-Message-State: AFuF++mgwsVuR2bFNN2P/ioTuoyjoH9/ZgUnSeBNScn4AT1qnTNASSE3
	tFH8VveGHIrVCflLikXIPGHTF6XffYFTNaydLL8LbPbqiL4Gtjxkg43V
X-Gm-Gg: AYBFou0qmHNalrEwhu3KJ9ezDoZuxRzGKQhyiJsPBCdNe3l4PyWlL4xr2O4JSwS1LG4
	BC12oCCzHc8uHvVIoV6Hsk45QzqUIwQ1AeNYQ1wwZ7sjZnwJqKycR6TLYRlMYnSsP+UfGJomG+e
	nuAu/TdNIQjPsWtZfQ+XQKOi7nlVLny5xXUP4rLJaRyK6/LaxZEJlvWAQxza10P386vpeUeapP6
	+ZpmddKH+ByHx0T0fjDdyRQbyfP7TVEa7XzXIpILnw57EI55khe+vxCRXG0xc4tlHJt1TPuxK5j
	H859/Xduk9+CZ2f8ta0X4pXuniBbOhwOyyZB3YX+/jjJ5pQFuZqErSk9iVVh/fXsnX2G0PAKNX8
	ny8N+DGlqrJM6APmFmMzriZHaQYvIN9+uTXuxqKZrxPGilGvnBCtRqnPdowdrAL59ynTudp5dMN
	f2CoIwlJiuJUqWc3O88tnzK8ey9FHh0SUIaR+vMLAvayX30a7mWV5uv1irrgLAP9WZf+6jBP5IK
	a+iaA++n9alOtY3cQQwocfWIMTXjZOoAPGuBum5KroF6xQomy4phmbATqhqAUmjEQ==
X-Received: by 2002:a17:90a:2c9:b0:39b:2b5a:8dc5 with SMTP id 98e67ed59e1d1-39b2b5a9b24mr38222127a91.6.1789022332072;
        Wed, 09 Sep 2026 23:38:52 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33987ccf483sm10464300eec.20.2026.09.09.23.38.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2026 23:38:51 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, Atish Patra <atish.patra@linux.dev>, Alexandre Ghiti <alex@ghiti.fr>, David Hildenbrand <david@kernel.org>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, kvm@vger.kernel.org, loongarch@lists.linux.dev, kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, Itaru Kitayama <itaru.kitayama@fujitsu.com>, Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v2 07/20] KVM: selftests: Make the single-page allocator APIs static inline
In-Reply-To: <20260902164123.2546762-8-seanjc@google.com>
Date: Thu, 10 Sep 2026 12:06:11 +0530
Message-ID: <ecf11ulg.ritesh.list@gmail.com>
References: <20260902164123.2546762-1-seanjc@google.com> <20260902164123.2546762-8-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Sean Christopherson <seanjc@google.com> writes:

> Move the single-page allocator APIs to kvm_util.h as inline functions, as
> the are trivial wrappers, and unlike __vm_phy_pages_alloc(), are expected
> to remain that way for the foreseeable future.
>
> No functional change intended.
>
> Tested-by: Itaru Kitayama <itaru.kitayama@fujitsu.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

LGTM. Feel free to add:
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
