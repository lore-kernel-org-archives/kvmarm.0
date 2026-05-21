Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C431F3C9429
	for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 13:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779371013; cv=none; b=Vp+DtoTT0MEUhw1VN8DWq0GuvCqEKVgKPgUgY5oorBXxBLmGNOmqfOMaUV1qIKJonfcgW1m1kgNhYkfiAW72KwAV8Uv1x3zBhfmBpA1g5s956XcpoIwEOkKedfiUcTw6uJjWDLDayYfcJbW6ArTjZhIOeyHJg+euVWcQYEhi88A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779371013; c=relaxed/simple;
	bh=ihm/lVAqjHvH5CtjwyR/6jFq5vTyseOiRiFwrlix/MA=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=cSHX//bGejOzh4b78CaaKlC8Ge5HJWa7c+E5BsdDI5fook846nMjREVTpPBbWdSFGOZ1o4+F10XPBcySW6C251eB89HbWz8M+m4AYY0lt2IBdeiorLbSn5QN724y4c7YR8quCShWKDcC6L87143EDQDcj2qIFGxqqk5KJmOp2hs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UxKGICbK; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UxKGICbK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779371010;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MGAqhEoCrxlhG7ghF4d4bubuWjp/PvPTdNOMZxG+QiI=;
	b=UxKGICbKBk7+ZfMSwN2eCAnXlwbnugGRW79hsolGrJH5mX9cGcVo8qZptQnWiL77jpvCpM
	tWdNk7dP9nkwt7CwJ9OgAomt/YgWp/YCYXpQ3LvGgT3/KCGRQhhVp4Dz18Sl53kUOQIs4+
	wk6yaKXIx4BeioXEeqjtV44KLgszIdk=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-82-oc0GY_FLOeCtIdkEiXuN9w-1; Thu, 21 May 2026 09:43:14 -0400
X-MC-Unique: oc0GY_FLOeCtIdkEiXuN9w-1
X-Mimecast-MFC-AGG-ID: oc0GY_FLOeCtIdkEiXuN9w_1779370988
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-48fd396daedso38139705e9.0
        for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 06:43:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779370988; x=1779975788;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MGAqhEoCrxlhG7ghF4d4bubuWjp/PvPTdNOMZxG+QiI=;
        b=bDMBpYA/8BEwIs/BjItYPgiTwoHEODu0di7WLaIIpmt4nI2d6/bbL+UTKUwMQX9pSn
         MIZQV3DWeNXfxlGMeRuROlxLGpDqMK+iwB1AW9Hbx0sX9v9if+eplCaDwRGY9Y6bavFX
         2eVrDmSEcJSbZgmYQLGXsqI1lVAHY859jR/oZp7kUDISWaHxNJ8ajBlbBBGp/faTCOvu
         voswXum5YOGeaRe7BYVRehUvmHWYQlMLIZ4ORuShblHRdjyicPcVHcaVMZNJXVEqFRF8
         efDYuKZr2eCkOcNiy0NEZmZvBoShyIpY8ReltCgluPuOnG0c//OD/KYwzmo/veTBFvUw
         A9Lw==
X-Forwarded-Encrypted: i=1; AFNElJ/lfW4Kti1UYVDHnaS/3QQaIfzQFKlAwBuVlFn6CQwbVoJpc6nfI1EzWsRWMnaqsDs1gX8FyZU=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw+5sPI8v0Pj9h3lM9TaV9ONVZvg3aVGZJfEDtlUiiGJ5ovUcbb
	d9AueWKOO0T7x9Y/qYdEcNB4VtfiPNLz6hEjqwGOcLGvVLM6eTjRHbMuPh2zm2CXVrkiILxxGxW
	g4cL9+nqnUOazicYT7teEQjxDCpAutOl2dMMa/2Cs4MI/O2go9sojBk8/yw==
X-Gm-Gg: Acq92OFHa2JXACy1yODiknQKyuqJ0PNBeW24nKZ33czYp5C0si2l1X90/q3pOn1Spfi
	1rkp6oy5gt+WlGF4BS7H3yp8nSBoOakmb6pfh3llWwM6USisdsf01OrODEejG83XMeyCcbWt6sR
	ix2bkjZuJNBepnCVo0Y0d3Soy+HG9pKgQ96Z42SDe+2m6NNIvOFk8RLTtwRuuDwxBtUhdlQjC+O
	8mpT4/JHkWjad4sh3bkFMhFEa3HwWwFfJGpYkStjRD7+BV9LkU558+xoH+iAdf4J46paNxYMTfg
	uSFS6OWrQYpP5BetWLqIIQ2z1r0r20Ue3yFFwbtRHPFHgi0vlW8MLsOZzGv+uELH76Q24kcwEB7
	dfYAaahxThaFDNGrO942S/kJbxHC1DJdH4LdGIN5ySIaN1/piWPAdsPShr3xtrfzFhakZHXc=
X-Received: by 2002:a05:600c:8b05:b0:48f:e230:c3f8 with SMTP id 5b1f17b1804b1-490360cc5d7mr57949795e9.30.1779370988579;
        Thu, 21 May 2026 06:43:08 -0700 (PDT)
X-Received: by 2002:a05:600c:8b05:b0:48f:e230:c3f8 with SMTP id 5b1f17b1804b1-490360cc5d7mr57949245e9.30.1779370988239;
        Thu, 21 May 2026 06:43:08 -0700 (PDT)
Received: from rh (p200300f6af2a6100f239e076bbd76784.dip0.t-ipconnect.de. [2003:f6:af2a:6100:f239:e076:bbd7:6784])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49035c219a0sm17063105e9.5.2026.05.21.06.43.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2026 06:43:07 -0700 (PDT)
Date: Thu, 21 May 2026 15:43:05 +0200 (CEST)
From: Sebastian Ott <sebott@redhat.com>
To: Eric Auger <eric.auger@redhat.com>
cc: eric.auger.pro@gmail.com, qemu-devel@nongnu.org, qemu-arm@nongnu.org, 
    kvmarm@lists.linux.dev, peter.maydell@linaro.org, 
    shaju.abraham@nutanix.com, khushit.shah@nutanix.com, 
    yangjinqian1@huawei.com, cohuck@redhat.com, richard.henderson@linaro.org, 
    skolothumtho@nvidia.com, philmd@linaro.org, maz@kernel.org, 
    oliver.upton@linux.dev, pbonzini@redhat.com, armbru@redhat.com, 
    berrange@redhat.com, abologna@redhat.com, jdenemar@redhat.com
Subject: Re: [PATCH v5 09/18] target/arm/kvm: Introduce
 kvm_get_writable_id_regs
In-Reply-To: <20260519132905.145643-10-eric.auger@redhat.com>
Message-ID: <f37a332e-1c0a-1017-f7f9-4df8a92459eb@redhat.com>
References: <20260519132905.145643-1-eric.auger@redhat.com> <20260519132905.145643-10-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: k2aOFDjc8PngpmFnoDTVEqE2l_Y3h6nBJf1tyWTxwW0_1779370988
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; format=flowed; charset=US-ASCII

On Tue, 19 May 2026, Eric Auger wrote:
> From: Cornelia Huck <cohuck@redhat.com>
>
> Add an helper to retrieve the writable id reg bitmask.
>
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
>
[...]
> +int kvm_arm_get_writable_id_regs(uint64_t *idregmap)
> +{
> +    int cap_writable_id_regs;
> +    struct reg_mask_range range = {
> +        .range = 0, /* up to now only a single range is supported */

.range = KVM_ARM_FEATURE_ID_RANGE,
.reserved = {0},

Reviewed-by: Sebastian Ott <sebott@redhat.com>

