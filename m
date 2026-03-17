Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5334D1D61B7
	for <kvmarm@lists.linux.dev>; Tue, 17 Mar 2026 17:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773769850; cv=pass; b=cU8KxeulRks1VCD2td6nj6y05dkAUYrzLjRC6Tw/OnsUE7ZLK3w5HyRetua5F/cIAR9MbliXXhYWXYOU2Rc2Ifghx9U/JS/hv3XwIjp0uzp8tn1j7V09ps4Nc4ftk+AbZ6REWYya+2NAM/emfZ2CQWfhumLa6c3+uSXyATqG80k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773769850; c=relaxed/simple;
	bh=HQ4Y3SNAjkSdp1o4EWGkyGe3hFuIuuTJjcqZJPi3rqc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SrNauFsvuXR8x5516rmBMSbdZmLcLCKZuRVQ0vH9MkfR0KuLa8mD22V2NsTmUqVGlYoAzzC86mQta5zpi5fikV2Y9je5Ti0yY3j64pJIszQ6+aXb5k62kSZqyry67KIO6vzEP4fNIQaNCAiGHcUjbIeKyO1rqGMuxOYXqtUxUGc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YhgLdg6e; arc=pass smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YhgLdg6e"
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-509062d829dso52741cf.1
        for <kvmarm@lists.linux.dev>; Tue, 17 Mar 2026 10:50:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773769848; cv=none;
        d=google.com; s=arc-20240605;
        b=e0hJcq2cYdvGoqMUtpfisMfcMGH6FuzfeC2sTLRLsULOM0lulFyT+3drzBS/fjnUtx
         vYEIazzzs1CMUh2jp73X+V5Hfq+LasR2QhiBdufzOoj83+Yzw45zGpyCiJ9K4KVdBWSj
         Q0cp90VhWfdavysJaGa5jH1I5qYieMHsPx4QeSs27hiiHbIa0Z7mZvvj3+/E+pUUcGHv
         2yqAImh6vJYw9rJkRu/e9MEgKZkKLBKoU1J6atwWSU/nHw/cT50KM7eoczpyItu3N3I7
         MPqiAK4qKAWZ9rc1ausP3asrZmKezfJjURI0gdZqJYOVsqtM0rke/Dl22GMJ99bFd6pb
         Ie7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=sswj2hGPn7hACbzJu1C3kS5DGnqFPqoGYHrtWz1tGw0=;
        fh=clnHTzAvt4aYOa2Pra7MMfnGJgWCg3sy4xV9cvJ65Tc=;
        b=TnEiN8CppErpQpS7JYjvMAV6GI6jBlbO1etSqeeEq4WxXAsECDU7U6PaTSciiK2TPw
         DhRCndxgYzRFRIHn83e6WxghkofeXqcY/4L+DgDHjtTwgSJJzgNyaEEZpDuJKxI6BYyK
         9UVFiJSTd8pAu3QMORQ/NyDz4rOZnHVGI3RSeg4QQ/LdHvwaXK2yUIACsIuhutGF3VRv
         qNeE735IaBklC2t0zRxRmMB3vMchA+5kj54OZp1y5KGgkvDEKyvZYxd4wrFGM5U01eGB
         Q9GSnj1krkgiBDDStYugEyOanvPyM+awe+e3zeTdVsQjx2sWYRKwJJVeiu3EbxIzMGds
         5MUQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773769848; x=1774374648; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=sswj2hGPn7hACbzJu1C3kS5DGnqFPqoGYHrtWz1tGw0=;
        b=YhgLdg6eAh0UWtAimDk73usOF0bmtr3SO7KFo82ZSagT+f52b45Be6suz7bze1Fgj7
         M97hEYNyv9WLjwSoagZz8pA/mRL+Z3tGldhnIR7Dfb5m/oTPQrAgpOk1+2OcdTK/6C+W
         h8tM7q76nGQmNgVDMfEZgfs5Njxu1E27s5Rg1bpEGq7u3EWRTPQoMxrESygC9akypl9K
         5n6nM5DxXunwEQJ9cTCp8rvFhU6zF3PcvegW/LwDn5GYzKHRTeXFqodeKvKIJNxVXNhT
         ZRAX7h/6Vz89FTh9fdxxg/C8DRsJSICk3rGsWnDzVZGQQ6bj9w6dtxa1bgnIr6gwIO7U
         8Kew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773769848; x=1774374648;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sswj2hGPn7hACbzJu1C3kS5DGnqFPqoGYHrtWz1tGw0=;
        b=jHon11hfhGEaaaYo5vU7DOCx0g+521ddoIN21JSaeC4AINAJ3do+MA9e75TRVn1bXX
         G7EsMzLNGjTmE/sRkHFeoxHhWE8/60LxD658bpXWkUYqvbfQuwkVlCyyva8yyJFRrkGT
         U/LVqdTLouD0PYM/WYlRopagAa45SNTZA0Kyx06w8GMEnSU+yH/b2gVFvO4yGSmxQo06
         Wh+8r1ifDnRTTh2eQXKqv7O7eOpC1jHpsKf6jCyVbiG5ZUJrmQxvrXWsUr6+nRpg/j8t
         QqarVPPeWskz9oABghzSJygYzlNhrIJKDysH98TxaBdmANG5rZA6ZE3OSnmPR8nYEne/
         pHkw==
X-Gm-Message-State: AOJu0YzR2IcBx8VC/gM+5KlV0CUDw8cTuX84SFEw4wW7YnNyjJ2Xqgu0
	Xfi1kTxhJ0dsPkn5zAqhz6QYE4vc/yehSDOeEumT0iwDN23OjapHc0rjmJqy6YqY8n7zjg2FM5L
	vmGzDZqthSZEIPbUNOrkXYU73U2+kUgHg0F9+oiEe
X-Gm-Gg: ATEYQzysPLcA1pjhIdvJyLmi5TRIqMRdXL3FqT//OkPGuDF0EZ45rt1K3YHdMKBQLh9
	ineq3RdAzEdnNMO4q3NmUrNKo/pen5JkhlVGf4cRQfKcKkdfWox5byYuahif5fHAkXOo1eIfyqm
	6y8Q9MC+2ZOvdsADWOrt0a1fytAwNMOPkWOppcO5TKsqHjK900qUoo+x5x+Vjsf55M3XKgsPgGn
	yXirVk1Pg+j8cca5go4r+YIuLT/gbX+RJbdvTTxmzvgvjF/XYTwOl/SShO/UPNzMpIZsVVVEBcV
	dV7ojYiX
X-Received: by 2002:a05:622a:150:b0:509:1c2c:866 with SMTP id
 d75a77b69052e-50b149575bcmr639391cf.11.1773769847627; Tue, 17 Mar 2026
 10:50:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260316175451.1866175-1-maz@kernel.org> <CA+EHjTyBtM5idopKisJf_e10aRifubtKEpbkjkEnmrOqa9-SPw@mail.gmail.com>
 <CA+EHjTy=MCgeKoi9sA_eDuiODucOdMP5m4CAciUW=rStgJggmQ@mail.gmail.com> <86tsue6ezy.wl-maz@kernel.org>
In-Reply-To: <86tsue6ezy.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 17 Mar 2026 17:50:10 +0000
X-Gm-Features: AaiRm52IK_m_asWK40sjcdDbExP97mzvrGS5v04I-bgwMBnhcMwSUWouKHa66FU
Message-ID: <CA+EHjTxF9fLtjdTtJontFuziRsgGMeE0bvEjHYqr64hDK3wLVg@mail.gmail.com>
Subject: Re: [PATCH 00/17] KVM: arm64: More user_mem_abort() rework
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>, 
	Quentin Perret <qperret@google.com>
Content-Type: text/plain; charset="UTF-8"

<snip>

> > > The series in hack/user_mem_abort-rework is different from this one.
> > > Here are the first few patches:
> >
> > And I just realized it's because they're based on _my_ patches ... doh! :D
>
> I thought I was clear when I wrote "I've added my on take on top of
> it", but maybe not. In any case, I didn't feel the need to redo what
> you had already done -- I don't think I'd have come up with something
> better.

You were clear. It's the reader's fault, not the author's.

I'll send you one more patch that might be worth adding, but this
looks great! Much easier to reason about. Thanks.

For the series:
Tested-by: Fuad Tabba <tabba@google.com>

(might as well repeat it here)
Reviwed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad


>
> In any case, I'd appreciate your feedback!
>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
