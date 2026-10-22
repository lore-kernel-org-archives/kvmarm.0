Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.173
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792664926;
	b=EeM/tCy8e4+qcMv6bjmxuznU7we02uKnl8yYvajPZ5hI/9hW7MntSC8CUVLCcKPz6SvT
	 cLg5XWrkFnmgokNYIpZ65oBVMpsc16TM3jK3GLGoRhDc92cldBEWXqSfX3BTOoNaGK38g
	 IwhH+Mh4TBioBJt75KP5Qf3CEC19l8eBFC7EZS82e1p44jGw8qQ3TKZviTY2qNTjZYsU7
	 8mat7eOsbsDkmfkB7oJ15nTn8DdmY/trjjxuS8tWXWnr2g8m34NIY92SP02AZfSTYdwc3
	 5tZyli7EDiumUaVSJIjCAjgdXQUrCpj/QGu5WR2B/so6FDL7BjfE37xJNWJKyNDvVxQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792664926;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=R9+slaVplhS0h+TANs82YWQX1if6DaqQLvnNGQd68DU=;
	b=zwz2QU0Ur+p79jlmOIihI1k7yZp1E5oxNtxV0v1L9VKefQFwD0NCpZ/BMBdBzXU2+gFa
	 oigwP3EC0t1EScF5pulv9LECxJDqvC+LLaVivIsfsgLLzf4DFjOuAcHTVZ2ozbp1AzKK6
	 2FuBakVMCDvOjWkYF4S4I5ld1ZmSKJ+4dPnUReOosqak8Ez4IuT8dC+l6TkkCuKWI6jjc
	 yPfPv9zux1vn28g80QYc8POjgPPTxHIWXnVATtk9qbYH5OoARXmKDdMxfbpVFg2owQCam
	 bOBU2qGHvOzpy63GS7XUHR5xlsPGS0G9/mcZ/MkaRE7WTHcGnPj/3FrzS91kjFBjCfg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linaro.org;
	spf=pass smtp.mailfrom=linaro.org;
	dkim=pass header.d=linaro.org header.i=@linaro.org header.a=rsa-sha256 header.s=google header.b=k26ho2Im;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.173
Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2B66606A31D
	for <kvmarm@lists.linux.dev>; Thu, 22 Oct 2026 10:28:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A2B66606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=linaro.org header.i=@linaro.org header.a=rsa-sha256 header.s=google header.b=k26ho2Im
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-8b0db268bd8so10722437b3.1
        for <kvmarm@lists.linux.dev>; Thu, 22 Oct 2026 03:28:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792664925; cv=none;
        d=google.com; s=arc-20260327;
        b=R8SGnmyvpzj19ZyrB/+7gwyUy4YGRqu9tfzx8BQ7FOC8Rj7BVr1QRAy/JLWy9gaaHL
         s/a3EEjAR/jzBSlSDGnKPoWM01ZGvjeQJTwQDBK2XvLsbnwv7zyzVGm9iV+QQoO5ysuF
         vED8IvFBchCS/y6rjrpFafDdXyJIK6lTJAtta2WKzm58w7aiwYCAl1HVGifCbqTshuTI
         muWxYj+AdNSr3nI1hZUG8qdqbAGFIjnjae2aY3VvnX8A67MXcwJyqVgrCrzcQmO0hCVs
         Wpb+5Fc2pTBSgBf5SIydMVqd6Sz80/4Z5bWByNqPXD7QyWPm4+j01R5y8enzNcCuGbkb
         pmww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=R9+slaVplhS0h+TANs82YWQX1if6DaqQLvnNGQd68DU=;
        fh=vgCIJoSaz1i+f6Nc+EEGEGAbdCSItqJgHjQMNRX3pFY=;
        b=e5yfzUF3mahjyHBLR+qnwRb1u7so3aGEn3qYsIDjQIRB8SbDgtdD0BbzWwWMv0ipfn
         GPkOmRR2oDsfLla3CHnTCV/kzJRH9Oi7IlXZyabSjuGjxzKTR4wZRrRbttzv0YLodTac
         CJIuUdkIakEV/Sxu3Y+lvoXw9NhkJRl5GTOD+EPwx3OYldqHm0IKjj+cGSLh4fF7d4rS
         qfM8Ep1PYccBF6t3bvqASs4H0XG0A/h8dNZx/RDpI0Kf96yXlJB7eG9eMCLb2l7lLt62
         OwqmH1iM5xZtKD0YnIBk3A6ZYu28rcWpnozR3/WYciMrn00y6EXmTDVACzekqe+xSttu
         1qVQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1792664925; x=1793269725; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=R9+slaVplhS0h+TANs82YWQX1if6DaqQLvnNGQd68DU=;
        b=k26ho2Im8SUlrPRYA49duW/YurgP2JNbmSJ6sqiY1odqORXin4krYtWaamALroD9rK
         r35cFBQTbWiIrfEU1VPXmVBjVbLU5XawB0R4W79klXxFblnJCiboGfHLEUM0nsmeztk5
         PqDMrLAc53/H+pPhAAdYW30JwXLK8I9m3nv1TQHYvh2FaB13uXmd8wJfTbEK9Bvkdpky
         HEBfl517h8JR3cbpxQs7csLQXCbPZtlLgyt6WhRL+8/rSoKlEFkFySOvYnK4cq3OiRTX
         TCRHocSBim+IYxUUT+A3mk0wc773WpHuac4eXhB3R9AjjwSTqI/oLgpqCj1pzN6CofWI
         3D8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792664925; x=1793269725;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=R9+slaVplhS0h+TANs82YWQX1if6DaqQLvnNGQd68DU=;
        b=1+FxXEs72Pw1o3FWIPe8xlO4LjOJ2ZywaaRk0RzvzfNapvZXClfL9pvTRmna7muIPa
         Tc95UDkCZQyZ+kS3o6u9aK1Uk7xymmroJZo9XQU8fhLXix2Uufo/t1kVmV4UPFPlsczJ
         ccMvS0kuk9AszgdbzhNk2TazIx8xOTidTyBK6FmHT0m8eKsga64pydJ8e6feCyLwZcyn
         wC/GKe38NUrGQKc63ff36n82a6pTFw4Lm7ifDV8UptlHaiUgSrEDQ3eBNv1UNBwrblOs
         FhHOs2ijfXVdu2V7MJbWVf14aU19PY3rg7VZs2JT/IscsUduNXTWYIQsYyzHFDo0RPKx
         uOrw==
X-Forwarded-Encrypted: i=1; AKwUvBxdAiD6EetrRb5aTUOrejZhRzCykH3dOyJb+2JDFH1LxLnN9NrvfjXqqZhYZm5zqs3TNGWL8sw=@lists.linux.dev
X-Gm-Message-State: AFq9FYJT83qBNl4ePeD5IrNAXLf5Y5udngGh+Ww+Ib8HKQurLjg1BlOq
	SrAUyJpyXEyx3nGfi9hXd5xZMe9OllPEbqZWOU7kk9v71NVEBvg1g9cqv6teXOHEo2h3CgX5ggt
	nXX33d4pQVB9M0KYV+nGrypCXO5e12UU6X9wKOL6ylg==
X-Gm-Gg: AYBFou3SXL+WptDgrDlFP6jPlV3wx8mZQ99llsY/QT8+CDRwJgllvZLdcXUbVHVgqnC
	rfDTedEQONkD3F3Pwvo9iqxryvseKp3l736Q2lFn3RQthb9QtsM89Amy4sH6tAlpgePB2krs/QJ
	e+QxX2q47vHcQ7iIyu7EfhBgcrdy5DaVlIbol4m7k7TGcis/EIGOOYA2YolGNSY9FVCH/f4o0FM
	S2X9hCCyOauviX28tNF1PsQdK2751iq+gcP37H6zobSAF6bTWOQCFS7n2WhIfpukv58t8RsI0Xq
	XbBpOBHx49f01gScudt14n8FeOOtqYqxo1wkV9W63turTFHDIuOpKcxmvvake15NptjkGsQIHzR
	uyWDAM872RthhyGabL8jmCSCGHhJMA2NrHm0dOFK8LI6qi1gEHDCl83dLAZ6qfr/nAP+f0wXZ1r
	eeLp2ENCXBpcxpAV4dt4xl
X-Received: by 2002:a05:690c:e6:b0:8ae:85db:8e48 with SMTP id
 00721157ae682-8b134109c2bmr25286017b3.68.1792664924530; Thu, 22 Oct 2026
 03:28:44 -0700 (PDT)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261010133725.642498-1-eric.auger@redhat.com> <20261010133725.642498-3-eric.auger@redhat.com>
In-Reply-To: <20261010133725.642498-3-eric.auger@redhat.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Thu, 22 Oct 2026 11:28:33 +0100
X-Gm-Features: AclHuK93dWwl-q9PlNiq8ZHRWxeuR0zJWNXIhDag3YFIxNwVwRpCtcfZs_60VFo
Message-ID: <CAFEAcA_cNP-Gb2_r2xFW0qUUBrkygNpN2kxhz2curXfXXeWtww@mail.gmail.com>
Subject: Re: [PATCH v10 02/26] target/arm: Move MIDR into isar.idregs[] storage
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
> Move MIDR into the isar.idregs[] array as other ID registers.
> This will allow to overwrite it as others.
>
> Signed-off-by: Eric Auger <eric.auger@redhat.com>

Reviewed-by: Peter Maydell <peter.maydell@linaro.org>

thanks
-- PMM
