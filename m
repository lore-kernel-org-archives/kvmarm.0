Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2219298CDC
	for <kvmarm@lists.linux.dev>; Mon, 15 Dec 2025 13:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.180
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765806259; cv=pass; b=f0RZBA/zg9mgbzXP3LgEG26t9J9w9N4E14/m+t91LtBBfUBZ+zAKpZwLuodWuhO++EpDDHEtUxlEPWkyIqXpYdfcDBKSkgFOotzKFhw3tG5VXrmlXQpZemGo69bHDEqnKMNzOy8EGPIO/Q/SPtyTjX9uYGufoD71zxwLG15tzBM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765806259; c=relaxed/simple;
	bh=R6XK/eGpbGVr6Jgp/rJRloKhM6PF1cJk63iiZSRID4E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ab/Lr+UnG3Ca82DIjz7d6NzbFA/jJ6lWKoG4kKR0F1xy4nQqsoZp/w/vXkHScPso/aTQ5Fhd6MYgF0AOKq7XPeEfvwl+TwF+CrMFNGkdPkkaC0IigP+60DIuCZv6EJ1wVSZl7QIaTRZvQSB7nP3dx57rxM93fs4DECP4h/MYEts=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PRJDk5am; arc=pass smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PRJDk5am"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-4edb8d6e98aso2575121cf.0
        for <kvmarm@lists.linux.dev>; Mon, 15 Dec 2025 05:44:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1765806257; cv=none;
        d=google.com; s=arc-20240605;
        b=ksElAQFnHcWo+pUa2DiPuCVjyRrv2ypl+aGQ2BF67oqE9fI/xh8/+B0PL6uGOv1SqL
         sDEykXVpHRdqvYxXCmPjUwmxn5sHwLQRPTnrNXwIrpJq+p81HIHdKaElCzV+8nPf5YoK
         NF5zXwl9qNcHEeWvgwaRDgtQWI6nkNKo1RVSp52GP3626kOyYPuns85t9JuM7K76eec2
         ZZMd8HLu3PzUhmSGBpG0KQUX5qdQIZOIelVaAHLtTxa012Y7Z5QKmmCz892v/6mZggVe
         PsbAgdzOZza2kA4UCTuJA9Ue/F4jtjD/QWjmLrjr5OxjcneYK3lvcW6iTPO4x/zJIO44
         0b+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=z14iaSBvakTbRSriw9RW3Psn7q2YVJ2taWiysxJXMkI=;
        fh=50JCwx8JC08nCWYFdJmr+T8iQVPeOfQk7Wli68gD+bU=;
        b=Cu4VP4JkOV92kSbFm6VkvM2krkavRCnT+AokmdUyd4IjG85XxIkcGFOanb/hIXVu0y
         K/SaEBVmf9xddRwEd7rW6drdlqzNotWdTQX2+L/UMscw+zlTye21f3wsX4LvW8LRsRtU
         ABdPB1e3S9/hKYStEmoP2+ynaR5AlZ846vnCeXI/VNb1KOVD/zjVNGWwWhx1FKQ6Ohcz
         xLnEWvwll4+ZBoV/fNmdnRJhSiaJZvmsH5KyV+SfmlO+9qDVGwN0g+eC2rRbhihZpVHf
         jYrlvRDGCkjl8rS3gjXtlfChS3cYwF63Mw1mlvaGmPd60Yquon3SfGz2A6ZU0Gy1AHr2
         rItg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765806257; x=1766411057; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=z14iaSBvakTbRSriw9RW3Psn7q2YVJ2taWiysxJXMkI=;
        b=PRJDk5ambdTiu+CwOQa57dLkKFqiIfAmExswb1hxZuYntDw48tPNrzeNp1NzmfNbnO
         Oy/qgXVsonfyhNlT8N1Ey2dL60Kt/KfhE1y/GV+BAHIhwNdyiMSwMuT3jXrk3KM9xKcj
         gxnq5QJh/5WiEU1Ftgv9TBNv1HIRDSP6IQv6Mf8XRHz6m7k5NwmlHN5LFflVpI4l/0yh
         ByNU4C//836coQ/JyWEKrbQD/g6zBAviW00POsWktigRzACHD1jfOaumDZWDgNGJdJ42
         OwPFU9y1vHmget33akBKmrpitZvq5oBI45n8NtI9yXmd0WNf+StYphFLeDWviWPoRNlG
         2Piw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765806257; x=1766411057;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z14iaSBvakTbRSriw9RW3Psn7q2YVJ2taWiysxJXMkI=;
        b=TcaN24+0XQPLgZ9ExRbXz5wmRK/Q6np74Bwpbquaxp40/ovWvs+TUCxlwUqxn0wjzq
         iMyROPMUe5o4UmW4oYgqO4Rs+O/aQUoSItEgoPss6cebymez22/CGfFf39Jo1x5QGI/k
         Ps8j4jUTazPIfT8X13TnYIyLXsVbjWaz25m3ctoOdHCKPuz844e0p/V2vFxQzEbrc9za
         qD+ucVpYqzKxqSNF/nsHF3c9buQSzk1HtwrDEbY1vFwN4k8NcSMV/Xj1vCxTnwhy3El0
         TK4hkRFpu63xgQidUA8ERiQtVqdDPbM6QQnF2jMPkO/sDsDF+VHWK7KyIVdqwsKzt084
         gxqg==
X-Forwarded-Encrypted: i=1; AJvYcCXQ/2PjN6wc7kgNuYzFWMsaANA0VGwGC9ToPcyuc7O3cjuAO+6od/IP5a8tQ4Cl8IHTD4E4rgo=@lists.linux.dev
X-Gm-Message-State: AOJu0YyMAN6jUF4St/OxOkM/lApLWsudHHBWrhXQZVd1+D7A+LZjKTg/
	pobPci7VOJZEdKdlnR+sGaj0hnK+Ct+ap/1bDyc7Ymcb/Go8w91HznJJqg/w2FX7NVKtvoMru+0
	msqCzK8QB9rGPSHmauXLlodOvq3wWS4H5uL2IcY/X
X-Gm-Gg: AY/fxX5VRqLOdOCeLzNXAaHI1NQ2W9KwTNibnJ+6H4KVdkI4tQeGnYzrLaJwZuc0ZuZ
	KO+wU1LVyclK60LYWKax2zdnXC/ARmle13JnZcGs3d53L2R7lRdDLujispSqaLrA8Wpxss5ESfJ
	uSqcYxq3rMIXCyvdm5sJbY9ucdq123QRxbO2RxlsIt7VEuTTFcwSzWKAfqRH3jPOVryGnvQQOAj
	qHH9Uc6cKHNjren1CV9PAOyX7X0lrBAqtVZYZpBcMjg/bVFFb7y3ikst5hqSmtRZQwXamcq
X-Google-Smtp-Source: AGHT+IG8mrjgb0PH7mXR+upNV1gkaIUUrVl2I1s9Je4zm7p3oJVmXi9AbHSsQyWlB8K3O5ElphjEKmXKH1yVjC7+JU8=
X-Received: by 2002:ac8:5f52:0:b0:4ed:ff77:1a86 with SMTP id
 d75a77b69052e-4f1dd5a7d3fmr21189951cf.18.1765806256280; Mon, 15 Dec 2025
 05:44:16 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251215114409.212512-1-alexandru.elisei@arm.com> <20251215114409.212512-4-alexandru.elisei@arm.com>
In-Reply-To: <20251215114409.212512-4-alexandru.elisei@arm.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 15 Dec 2025 13:43:39 +0000
X-Gm-Features: AQt7F2oX_hM1FGOiORaSy7SZ-wHBNvacu3VXZu-02xL_kJfEZQ81XXFjfnewTlU
Message-ID: <CA+EHjTz2rZ1ebh8PP_f8DkJ=zqF_yjHQPgtQXxFjCsvifGD1bw@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] KVM: arm64: Remove extra argument for __pvkm_host_{share,unshare}_hyp()
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: maz@kernel.org, oupton@kernel.org, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, qperret@google.com, 
	will@kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Mon, 15 Dec 2025 at 11:44, Alexandru Elisei <alexandru.elisei@arm.com> wrote:
>
> __pvkm_host_share_hyp() and __pkvm_host_unshare_hyp() both have one
> parameter, the pfn, not two. Even though correctness isn't impacted because
> the SMCCC handlers pass the first argument and ignore the second one, let's
> call the functions with the proper number of arguments.
>
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

>  arch/arm64/kvm/mmu.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 48d7c372a4cd..124404eb208d 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -497,7 +497,7 @@ static int share_pfn_hyp(u64 pfn)
>         this->count = 1;
>         rb_link_node(&this->node, parent, node);
>         rb_insert_color(&this->node, &hyp_shared_pfns);
> -       ret = kvm_call_hyp_nvhe(__pkvm_host_share_hyp, pfn, 1);
> +       ret = kvm_call_hyp_nvhe(__pkvm_host_share_hyp, pfn);
>  unlock:
>         mutex_unlock(&hyp_shared_pfns_lock);
>
> @@ -523,7 +523,7 @@ static int unshare_pfn_hyp(u64 pfn)
>
>         rb_erase(&this->node, &hyp_shared_pfns);
>         kfree(this);
> -       ret = kvm_call_hyp_nvhe(__pkvm_host_unshare_hyp, pfn, 1);
> +       ret = kvm_call_hyp_nvhe(__pkvm_host_unshare_hyp, pfn);
>  unlock:
>         mutex_unlock(&hyp_shared_pfns_lock);
>
> --
> 2.52.0
>
