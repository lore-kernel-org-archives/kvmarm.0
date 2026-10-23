Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.181
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792755901;
	b=F7L6Vo0td1FoVt2uyu9t6QSB6FKzWWBHdGLqPrgFN0s90WzxWR0QVIi+rtLcY71KXQum
	 LU03baKvm1Vtr33UCMmfBMJ5rT4hq17M/o6M8fvr7z0Cvie6xxvJAE8dtabGgyZ0/b1rQ
	 myMF7G+uBbDaOeztBeDoHbttHwYMjB8K9EC6tNWztmK4/2uw5EfJtNsrv4ME94GCkiL94
	 iGJFSqAiLdtyhnbEeBxvSdluLaTvwEqGRUcY+79C0PTqZxg3OHr95VaxN/ROJAzlEdqWN
	 O7khopDD17KrXYj4QGkFUKfWV4fAltydncLvKWO4LM1f205ldcki0jsO84aZQOolMpA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792755901;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=LJ3/gGSXFuZez0qoiMtJBNrT34Y0qC3xMuJpLq2A+6A=;
	b=49kDQV9vS/UWjxP73/4Q2eOFmdOkT02mCEqeSchiwUVpMQCmIR3otD13b4Mn/5+pYVMf
	 ecrpJj2lHqOI4tIVvqjPoVWeOn+PWnzWAdELndq2okhsS0O1AR4oaLNnAGV06p0dBbETY
	 CHEMoR5V2phsekgHe1nlykCScgrURQIpnCLABAonCxrdFrF2G8a09QFQqvWo09sTyofZt
	 DcML4gppy8tpy3/hoVZWDVF9CmtZoW+2r9YrDhF0g9KCdTfolwhg+cvCCzs2BCzjs7eIG
	 XqiwSxNYEKZnVueo0OAvMy41kJP0L/XOpSLqqu5bWFca4KPziPlM0+gMLsPsh20rWmw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linaro.org;
	spf=pass smtp.mailfrom=linaro.org;
	dkim=pass header.d=linaro.org header.i=@linaro.org header.a=rsa-sha256 header.s=google header.b=DIqO52yT;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.181
Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69780606A322
	for <kvmarm@lists.linux.dev>; Fri, 23 Oct 2026 11:45:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 69780606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=linaro.org header.i=@linaro.org header.a=rsa-sha256 header.s=google header.b=DIqO52yT
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-8ac525c1f05so7172647b3.1
        for <kvmarm@lists.linux.dev>; Fri, 23 Oct 2026 04:45:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792755900; cv=none;
        d=google.com; s=arc-20260327;
        b=qLg5GEfu4k33LoK/eN9FBjG3OGcX7vqHB3WBh21K+q4elB4oGyFVmzdqB+OKxpbHpp
         HFnVkODxs8MU+Bsu/oaVIBmF4u4Otcy6s3oqtpXfJd+dmU4O6ZDCbYvL/Dx6N3Sf44Dh
         XKsd4MFWSppjhSmFisoJI8fQLN7k3WJ8vXzHhEDfq3b3iMxKMShtXsd8eOrU6HC9wIr+
         SQUw+KFhn//cKiIuhV2704F8+zrE9w6L4pL0BR31gnaWV/lNlaKkPmXHGtRYd7w3V8fN
         krAJYqPKjsG0qfQlpjgHe2MwLd8Kk224/yRi4PEwoUyAgboZKYeXhBOzJzt8cg5aluUk
         PxNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=LJ3/gGSXFuZez0qoiMtJBNrT34Y0qC3xMuJpLq2A+6A=;
        fh=ugLDIyxvR+GaMss9gPYazRRdCsGvl92/OwXy5dI6KWg=;
        b=nw/sfey1t2YMydcqb76PsIH7IFBXdm+y/+s+OGjG0sY1k5d7G7htUkSNaoWHNLFOxP
         AVp9fM2XKKa/YlTW56Z6DKn827PHilsQua8Ykzqaet52Dpjl9HEpDzGC+O4wYykH+O7V
         QdMFDE6kNp1VZE1jw9GcmgWRWHoWpkxYC3IdUDhqrpY3rJJjKfAvsdmeR0jr3SqAKnI9
         ysol1DpSglsF4z8CTKfT7OvhkvSCUVpos6PHakmjHMEFNL07wKPqTCByxApi8Z5y4Mxi
         l70HYvjkkzMu6jxxlZ1DH06qHKReeEo6W33x7xvWLnk/58NbVAY0GnT/mIKgXtLlmQ2I
         ToXg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1792755900; x=1793360700; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LJ3/gGSXFuZez0qoiMtJBNrT34Y0qC3xMuJpLq2A+6A=;
        b=DIqO52yTGkZ7izWyttf2uDhRTbxAs8VC0XRz+VEkdH+hUmhKGxwbwTtwnpeRjc7qj6
         9vykD8LnURo0NHyfHj8nHHETPQI2k0SZo5V+LWLALd7w2BvQ+vYzKyFhqtg8vn9raGHA
         44BOET6z6Kjijxu1TIXyNoYbjApTZWGFTSRxwVA2q75rl/nipWcYgZBNkPIlPrBFdSMJ
         L7BbpbeCz8wc+Rtc+D1e2srg9OdC4dj6tnUOZzVLJoG6RAyhNxetdARW8w2NvjO6sQNL
         /o9EG2lGJ2dSPVWVVCFKkGr7PEcCZDlHqW4wPKmkIuihrAqQ0vJZG6cV3cu4nxO0LtBG
         s0Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792755900; x=1793360700;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=LJ3/gGSXFuZez0qoiMtJBNrT34Y0qC3xMuJpLq2A+6A=;
        b=FY5g+GzBPHyY7WRIwiQJY7RMkCjcbZfaX3w7Y9TCMwXvNE8aWZSe3kqnzDQpYarwA9
         XJD/OCyhuzM4co2wygBkW46mSJDSp7NsOAXC//h+TUqrhSvyIB1JT8WLNb8ECVOaPb9q
         8FjgyFX78YoLr99M7oUTPVVdGVMLRBQUMFqzfz9S26TfbSJzOigHmTm1Ah3whBJ2+4wT
         9XoZg5CAWbsQGauTVlBKu39p1dvAyrDiG3Epml4zhrMjtek9e3WZ8lHtjl0J+dZpCd+J
         5RfVP6Lg2oLqIZSXZu8aGzxopW4xu8ZN8+NJ5H+b9D87OUb0WtfEpUWLbkUcfgmThW7Y
         EehA==
X-Forwarded-Encrypted: i=1; AKwUvBz5qNNTo9UCPxXCzfK+axomxm5K11vqMmlgBsvACy1AzMnZA90Qk7qHHia3YJf+KEDI0ZqaSOk=@lists.linux.dev
X-Gm-Message-State: AFq9FYLvrUHgFvRMn1GP4qk/Bsz+2xEWsbJzL5roE3BF0PWdQEjVtILt
	WMn+NGRfcn53WQbdbIhUwvdnPrvTyhD7p/5nsQU1ngDGW+jS9gnfvVDwgkMnItNsho/Yl7yd6HP
	b0iB3+vcPxdllHawSpGCaizerpr/j3NeeHeR2O9/DIg==
X-Gm-Gg: AYBFou2NwgQTwxzJL7446U7vkKPUiJxCuX+FY3JrEwtdfgsyXefvfiNgdd9OChj6JtW
	8oMGVHcnVI9aE7wUlMpcFobdEQjJNaO0E8F7IivPU/H4Ac5HRqkaBnrRM48XXu5yfuhiCpUGoNe
	Z5KVJfQrxwmtSBonej8aozYKCwK+9vZRBmp260Eh+qA+tc6hniBxlHkNhgBR7DwrBuc6dFiXBUG
	qBECUDek41RICFxfUvSYTjCcditaZa237/eq3LzelpERSR/5zGE3bUpgZsM7eRv01Yik9cDBvRo
	DUAmNEqqPtHhneHK/hl/L5jmSBajJkzega87AcBKGMQTeKswZ9q8H8pojaNTHKdtwhVy5boXPU0
	nGQQhZToxal3SuixpqWaLsG4YIA+Wn9TTf/YfFW2Bo+OI7EiItx4MBjtSS/FKnonpfScEY0B2+K
	AuGj2OMgEf/ruIuuXGwjfA
X-Received: by 2002:a05:690c:7108:b0:847:d0cd:11eb with SMTP id
 00721157ae682-8b157ba2d78mr17589257b3.9.1792755900069; Fri, 23 Oct 2026
 04:45:00 -0700 (PDT)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261010133725.642498-1-eric.auger@redhat.com>
In-Reply-To: <20261010133725.642498-1-eric.auger@redhat.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Fri, 23 Oct 2026 12:44:48 +0100
X-Gm-Features: AclHuK-SOddt72tpNNxsXJ62VuaXNgbTq3dc6W6MUQby4pa5991PP5qOVGNvpWA
Message-ID: <CAFEAcA9XE0TLxp+DNzFSbkxbj7f0M78N+tf1a01cJ5rNkM7NBA@mail.gmail.com>
Subject: Re: [PATCH v10 00/26] kvm/arm: Introduce a customizable aarch64 KVM
 host model
To: Eric Auger <eric.auger@redhat.com>
Cc: eric.auger.pro@gmail.com, qemu-devel@nongnu.org, qemu-arm@nongnu.org, 
	kvmarm@lists.linux.dev, shaju.abraham@nutanix.com, khushit.shah@nutanix.com, 
	yangjinqian1@huawei.com, cohuck@redhat.com, richard.henderson@linaro.org, 
	sebott@redhat.com, skolothumtho@nvidia.com, philmd@oss.qualcomm.com, 
	maz@kernel.org, oliver.upton@linux.dev, pbonzini@redhat.com, 
	armbru@redhat.com, berrange@redhat.com, abologna@redhat.com, 
	jdenemar@redhat.com
Content-Type: text/plain; charset="UTF-8"

On Sat, 10 Oct 2026 at 14:37, Eric Auger <eric.auger@redhat.com> wrote:
>
> This series enhances the current host KVM model with capability to
> set writable ID reg fields.
>
> Since v6.7 kernel, KVM/arm allows the userspace to overwrite the values
> of a subset of ID regs. The list of writable fields continues to grow.
> The feature ID range is defined as the AArch64 System register space
> with op0==3, op1=={0, 1, 3}, CRn==0, CRm=={0-7}, op2=={0-7}.
>
> The end goal is to get more flexibility when migrating guests
> between different host hardware. This series is a prerequisite for
> aarch64 named vcpu models.

To help me with review prioritization -- are you hoping this will
land for 11.2, or are you expecting it to be 12.0 material? (Given
the softfreeze date is rapidly approaching, it feels to me like
12.0 is where it's going to be.)

thanks
-- PMM
