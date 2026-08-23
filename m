Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 621132D1931
	for <kvmarm@lists.linux.dev>; Sun, 23 Aug 2026 18:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787510566; cv=pass; b=Pp26KhDURlyP16B+MgtrmequFGQ9acw92GKtUoB7nwXel2+cGbNPRwTGH8+PzSmEgeZVqlMxY7VubeVJxKUYeDafbqG5wrqcXUfKjL8IfY4sNhJ1IBrBC1W44fPn+yj5BIgXH4FRqvqpHAN/C0tTyQwAtIsM4+Lsy6XH57EqDkM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787510566; c=relaxed/simple;
	bh=0+IeSPqNw2KbqfGmFRu0WOwcVJjzIsJn1LgqgmtBNR0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=V6QV2oAvdgAZaFyYXFtZyfaD/gfml5XNFthERhi6+SKGnoicqhQ/dScBS+sqOMIaXioH6L1FmhjmaROLtqv4mP5duaYw/r4KGvxuU04gWwmHlbLSapaNb8sFUYnC2QogLW9Mus7ZeJbvGlwlLAD4o5NaVUYPKQ1Y2p+rFV7SHAI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QGm/Y/Fw; arc=pass smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QGm/Y/Fw"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4996e2575dbso49375e9.0
        for <kvmarm@lists.linux.dev>; Sun, 23 Aug 2026 11:42:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787510563; cv=none;
        d=google.com; s=arc-20260327;
        b=Ho8KSsOy2ta0gbEKJu93jaDaQc9QzL4vKMKX6qRvbQkcp9ES7UaQVjiDv52nwweBeL
         CFtlqGIA9xbB82Oe+PTJz9sZPg1Nk+fFx0a3t4FIhq5TPfilM+Z/N8sVj+GI/HmvQNWN
         YfGXrq6gS0HoUuONGrIXcFeePQb5N57sEz+y3dLBGPORHHn3QGXfY0veyhlAAkdZ21NZ
         4x0/GgVP2AR6k95e71DqUq+wAZE3LuqLrQMZRrOo6QBLeLdGcKhpuj8Gb3jqlKykSI92
         eiSw5r2mYG487+s1cDA2YFCxbgIHs0gHEqXRAPVsoYzQtuOJGm5nXwb1atYdnIcJaXeh
         m5mQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=7QqxmDSu9ZKigGwHfW3p68zaiz3lbhfuyJNk3aAmOE4=;
        fh=Eh0s+SjQ1ZSxZTyP0uaj7CCqWd9Xjz5G4pOHMbr1hdo=;
        b=URu5tRQKlA31uccQOWW5sfQdmNOn2SRNpdFQ6CHlRCrYCrd8GyGGsOopwN5Ik3f0ai
         wZCS06/8JLv/W3BIDT8Qwwk+abZbRytfoqny0Na2jrIrI/IOHyN+NwScIdc3dIceg/7K
         7gTCgTO2fi/o+J6aPjz8MSo1RCYjEsNEg9zpngfldREPv+E2JY8iNVVTiVG1JAObDZEH
         SxYLsGBmSalLTI46lvNUueyu0EYcen6+YG8prCBciopPHUeSKkoVeIPOg3d/8CAVBgcU
         xegO1wfL4NmNR4a7HqfR08tpVw6ULjDJvG3OoqFk2uJ78+brFS5eR3T0wopW3/xwP3Bd
         rCoA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787510563; x=1788115363; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=7QqxmDSu9ZKigGwHfW3p68zaiz3lbhfuyJNk3aAmOE4=;
        b=QGm/Y/Fw4MzDqByhfdui6yg0Z/CWowWyKV6rzamQj/OP5zG+wampMMyLItVYbX0bQP
         x0AjoQRqaS0ebVYipoImjAaeHONuQU8u0/9qIYUVhBcNfhtGj6MighSZ9RRBUJ4z9qKM
         HJ7JTEWBZKS5co+Durwot11Ej2KrcFh9ZIg6CK66OyiSfUKiU1t4Ra4J8Ht9iLkL89At
         /c/VP0xSjE58fYO5HBRAw8EeM8wcYuECCqZQ5HXQ9dZPajHurbqP2o8ZOgSWokPD7WA7
         Q9RMjRwyqLQVWgXrKzzNoyerfeoig/HGIdmnZtNMhegpfTSxpF/ouEpjzg8xdl1xiD9e
         HV+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787510563; x=1788115363;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7QqxmDSu9ZKigGwHfW3p68zaiz3lbhfuyJNk3aAmOE4=;
        b=JePia3LNXtu9cFyTTMxcg2BVAdgY6eUwOqYyFJ2uCYXmut7kRb+h/N5g9oXXUZCGJW
         u5CAs1OMB1Pw0LccGVIRwqPaJ0/UWinrZHDCkznwqxANEhC2xX4SX9DqVcJNrEQT2SQb
         /NzIBrsC/QM71aJjfLPaFNDBwPa3Dy+0xW3vruIzrrya4G8Vmvs/hfc+VE6U+86Z0Rm/
         TFV1cSj4A3efPLnj0/B1SsmdLH0BKrSgMI0F6EW2uyTpw6yZXNL9xLhWe0guNQ2RwlLB
         8ZS+sknL6CXJ/Bnj7Kv6CvGuvBtmLBTzCZHczJcwEp+mTi6N6ZBBitbT7sB+1znP64zh
         r1Sw==
X-Forwarded-Encrypted: i=1; AHgh+RqC9kc3ygmOa9ym4fyU2IyFFZLYwcJJQ6wN4JZ3V6ZeuDZSrbfcoDJkEee455TU/56yt0mILwc=@lists.linux.dev
X-Gm-Message-State: AFuF++mf02zHVQuxgIKsC/UOrGTGsWngPugjnb7JAyvLBYlDaotrMzPH
	BXXrOIgiFeFE2uqO6c6bZQ4d9HFnWZWfA83j2YF9We0eU5APaUsiL2x5eMvuzQ+z/loBPrL/Ey1
	7cY4qIDmxbwjQlJXsORTNoSLGPvgOOzvGMze5qzil
X-Gm-Gg: AR+sD11q2tqu4+HH7FNvm+hqK+F575z28aKa+RbFhl2C5C5E6boqbYgiyzG24yyi8e3
	zTQTn8wXtEt4FRcP3xE2zMU5XcQ63WPGyjmYqAxtQ0lIIu6fJXsDux3UxMByuttEdCd/uECYTgB
	54O74SkccoFsHi2+9U7B76bLGBIt7vcN44+FzmrMAb/EWwuxwS0kbesOvPY79MXzONwFDkXic/g
	HJrFsE7eQsed14yPaoOYxvAjQDj4VP7KHJroclEKQFElqBiKEECC6zGDp3ShaJoerNYR7udxGyg
	N9AbohN5h8t64BSzORVGU/ZgZCkBPy+ec1KbWJ99UteYUZ//GgHV2f6By5aWMCpfdSbIGa8yURz
	u
X-Received: by 2002:a05:600c:58d0:b0:495:7a0b:3b4a with SMTP id
 5b1f17b1804b1-499c241397dmr1168755e9.7.1787510562110; Sun, 23 Aug 2026
 11:42:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260818112920.26252-1-likexu@tencent.com> <20260818112920.26252-3-likexu@tencent.com>
In-Reply-To: <20260818112920.26252-3-likexu@tencent.com>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Sun, 23 Aug 2026 11:42:29 -0700
X-Gm-Features: AcwNN1UVfQ0nU8MkI-sMZoCVlDC1rLeZSnymDq9F6Xx7kDJeK1PGVfv6PmTTlDI
Message-ID: <CACw3F51WrQ=5=DaKChPtwmf0030R3GSOPjrAZ9Og+V0VHuRhEw@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] KVM: selftests: arm64: Skip sea_to_user without
 1GB hugepages
To: Like Xu <like.xu.linux@gmail.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev, 
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 18, 2026 at 4:29=E2=80=AFAM Like Xu <like.xu.linux@gmail.com> w=
rote:
>
> sea_to_user backs guest memory with 1GB hugepages but never checks that
> any are reserved. On a host with an empty pool it aborts instead of
> skipping:
>
>   kvm_syscalls.h:68: mem !=3D MAP_FAILED, errno=3D12 (ENOMEM)
>   not ok 1 selftests: kvm: sea_to_user # exit=3D254
>
> The mmap() of the hugetlb region fails with -ENOMEM because no 1GB pages
> are available, and the test treats that as a hard failure even though it
> simply cannot run without the backing pages. Check the free 1GB hugepage
> count up front and skip cleanly when the host cannot satisfy the region.

Looks good to me, just one nit below.

Reviewed-by: Jiaqi Yan <jiaqiyan@google.com>

>
> Signed-off-by: Like Xu <likexu@tencent.com>
> ---
>  tools/testing/selftests/kvm/arm64/sea_to_user.c |  6 ++++++
>  tools/testing/selftests/kvm/include/test_util.h |  1 +
>  tools/testing/selftests/kvm/lib/test_util.c     | 15 +++++++++++++++
>  3 files changed, 22 insertions(+)
>
> diff --git a/tools/testing/selftests/kvm/arm64/sea_to_user.c b/tools/test=
ing/selftests/kvm/arm64/sea_to_user.c
> index 1c2a743ca8e23..7cf95da8e594d 100644
> --- a/tools/testing/selftests/kvm/arm64/sea_to_user.c
> +++ b/tools/testing/selftests/kvm/arm64/sea_to_user.c
> @@ -281,6 +281,12 @@ static struct kvm_vm *vm_create_with_sea_handler(str=
uct kvm_vcpu **vcpu)
>         alignment =3D max(backing_page_size, guest_page_size);
>         num_guest_pages =3D VM_MEM_SIZE / guest_page_size;
>
> +       /*
> +        * The region is backed by 1GB hugepages; skip gracefully rather =
than
> +        * failing with mmap() -ENOMEM if the host has none reserved.
> +        */
> +       TEST_REQUIRE(get_free_hugepages(backing_page_size) >=3D VM_MEM_SI=
ZE);

How about moving the src_type to main or global? Then we can
TEST_REQUIRE() in main().


> +
>         vm =3D __vm_create_with_one_vcpu(vcpu, num_guest_pages, guest_cod=
e);
>         vm_init_descriptor_tables(vm);
>         vcpu_init_descriptor_tables(*vcpu);
> diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/test=
ing/selftests/kvm/include/test_util.h
> index a56271c237ae9..0624922c2735d 100644
> --- a/tools/testing/selftests/kvm/include/test_util.h
> +++ b/tools/testing/selftests/kvm/include/test_util.h
> @@ -168,6 +168,7 @@ struct vm_mem_backing_src_alias {
>  bool thp_configured(void);
>  size_t get_trans_hugepagesz(void);
>  size_t get_def_hugetlb_pagesz(void);
> +size_t get_free_hugepages(size_t page_size);
>  const struct vm_mem_backing_src_alias *vm_mem_backing_src_alias(u32 i);
>  size_t get_backing_src_pagesz(u32 i);
>  bool is_backing_src_hugetlb(u32 i);
> diff --git a/tools/testing/selftests/kvm/lib/test_util.c b/tools/testing/=
selftests/kvm/lib/test_util.c
> index bab1bd2b775b6..29f9c1d60b1b7 100644
> --- a/tools/testing/selftests/kvm/lib/test_util.c
> +++ b/tools/testing/selftests/kvm/lib/test_util.c
> @@ -222,6 +222,21 @@ size_t get_def_hugetlb_pagesz(void)
>         TEST_FAIL("Error in reading /proc/meminfo");
>  }
>
> +size_t get_free_hugepages(size_t page_size)
> +{
> +       char path[128];
> +       size_t free;
> +
> +       snprintf(path, sizeof(path),
> +                "/sys/kernel/mm/hugepages/hugepages-%zukB/free_hugepages=
",
> +                page_size >> 10);
> +       if (!test_sysfs_path(path))
> +               return 0;
> +
> +       free =3D get_sysfs_val(path);
> +       return free * page_size;
> +}
> +
>  #define ANON_FLAGS     (MAP_PRIVATE | MAP_ANONYMOUS)
>  #define ANON_HUGE_FLAGS        (ANON_FLAGS | MAP_HUGETLB)
>
> --
> 2.50.1 (Apple Git-155)
>
