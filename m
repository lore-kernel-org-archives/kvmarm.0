Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83056C433FE
	for <kvmarm@archiver.kernel.org>; Tue,  7 Dec 2021 17:03:34 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C6F2E4B0B3;
	Tue,  7 Dec 2021 12:03:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id iPGMQxslbm+7; Tue,  7 Dec 2021 12:03:32 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 374714B0B8;
	Tue,  7 Dec 2021 12:03:32 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BC69E4B178
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Dec 2021 09:47:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mzcjDv7-BTih for <kvmarm@lists.cs.columbia.edu>;
 Tue,  7 Dec 2021 09:47:28 -0500 (EST)
Received: from mail-io1-f52.google.com (mail-io1-f52.google.com
 [209.85.166.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A9F004B116
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Dec 2021 09:47:28 -0500 (EST)
Received: by mail-io1-f52.google.com with SMTP id x6so17276288iol.13
 for <kvmarm@lists.cs.columbia.edu>; Tue, 07 Dec 2021 06:47:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=rd7GUIKIbCq02Oh785CODSXVlp0901h9nggHWlZlO8Y=;
 b=MkIwxN4odj9XaJ/cRzJ11aX1K3mmoC9ApIh8REQYQSIsB6CjAW9Thxnp4VloxRVLbq
 IuGExTsxv3/yBCg8F6Xp/Oi/yaaBmKR5cF5vwpLy6nDrdU5OmQiYbWFlR0eSQ53XMiHM
 GEYrR5ovDc++0syv02Q804GLBWskxd7XKSCbQLf9v9iWA1qqOHZbV6eQGGhjf9yQQ6yo
 QtUar9HofFRMtd9uZdnPUJbUBRX22g46aT3obt/YlUSQIFQLGrlE/bVsQ4JN//rTQwmF
 D33HQxYPaVbFf4LfvD7f8BBD01lVy00Pe39zIC/guIRYnpIIEw/nSOgv02qqBVEgSdFR
 Kt4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=rd7GUIKIbCq02Oh785CODSXVlp0901h9nggHWlZlO8Y=;
 b=EIzTa4r4oZ1YRdMINzAA6FjjUQiTBjMo3DC7zE+MgwDqn78I7HSl3CH9VvmeUT4Ug3
 21vy9mMmxR2MYgoue9g8syZDsyHKyv6z2r7ZlTUDbkODtXqH69nD6DmaDjFqE2QiWUz4
 +t4jkjbrkGLRkiITQ/g4F4i2/2FPSUZ+oaWT/RSE++iUzcMGPg7kZ+l/eP8PTKqwZOhH
 G4IADPorzvA92S1A2L20ofwxRTgwFYlfZUXUOJ96i7fYbDfFQoefr3JTHuHlELMXtqum
 JN5kUHvZh8Fk4xH+vzb5crY58/UTJtII2fjaHEEcenEjIzgKnV0TDmwpkLPJQIV5zqgR
 rZAQ==
X-Gm-Message-State: AOAM533Yc/z1jPwXoYfDYl460fie3Ys/Ejclswjns57/phViwauisGrO
 BKAnouooEFEUXosV6WltZYJLMj2qAG+UwufMKQK2Fw==
X-Google-Smtp-Source: ABdhPJwnGMcu2rI4em8EZHcweqOJLB9x+xndjQX7DQQZmXunsP8UoC+LbyZ5mPLcHi2luPhvoZ9SUSPZZw5WlhZST3I=
X-Received: by 2002:a05:6638:150d:: with SMTP id
 b13mr50067001jat.101.1638888447871; 
 Tue, 07 Dec 2021 06:47:27 -0800 (PST)
MIME-Version: 1.0
References: <20211201170411.1561936-1-qperret@google.com>
 <20211201170411.1561936-7-qperret@google.com>
In-Reply-To: <20211201170411.1561936-7-qperret@google.com>
From: Andrew Walbran <qwandor@google.com>
Date: Tue, 7 Dec 2021 14:47:14 +0000
Message-ID: <CA+_y_2EEP5tYbBTd17c1wuOeZ2jSfhgu0M2b=CpGKjKRgU-=gw@mail.gmail.com>
Subject: Re: [PATCH v3 06/15] KVM: arm64: Implement kvm_pgtable_hyp_unmap() at
 EL2
To: Quentin Perret <qperret@google.com>
X-Mailman-Approved-At: Tue, 07 Dec 2021 12:03:31 -0500
Cc: kernel-team@android.com, Marc Zyngier <maz@kernel.org>,
 linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1056448663922424150=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

--===============1056448663922424150==
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="000000000000ca51d505d28f73d8"

--000000000000ca51d505d28f73d8
Content-Type: text/plain; charset="UTF-8"

On Wed, 1 Dec 2021 at 17:04, 'Quentin Perret' via kernel-team
<kernel-team@android.com> wrote:
>
> From: Will Deacon <will@kernel.org>
>
> Implement kvm_pgtable_hyp_unmap() which can be used to remove hypervisor
> stage-1 mappings at EL2.
>
> Signed-off-by: Will Deacon <will@kernel.org>
> Signed-off-by: Quentin Perret <qperret@google.com>
> ---
>  arch/arm64/include/asm/kvm_pgtable.h | 21 ++++++++++
>  arch/arm64/kvm/hyp/pgtable.c         | 63 ++++++++++++++++++++++++++++
>  2 files changed, 84 insertions(+)
>
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index 027783829584..9d076f36401d 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -251,6 +251,27 @@ void kvm_pgtable_hyp_destroy(struct kvm_pgtable *pgt);
>  int kvm_pgtable_hyp_map(struct kvm_pgtable *pgt, u64 addr, u64 size, u64 phys,
>                         enum kvm_pgtable_prot prot);
>
> +/**
> + * kvm_pgtable_hyp_unmap() - Remove a mapping from a hypervisor stage-1 page-table.
> + * @pgt:       Page-table structure initialised by kvm_pgtable_hyp_init().
> + * @addr:      Virtual address from which to remove the mapping.
> + * @size:      Size of the mapping.
> + *
> + * The offset of @addr within a page is ignored, @size is rounded-up to
> + * the next page boundary and @phys is rounded-down to the previous page
> + * boundary.
> + *
> + * TLB invalidation is performed for each page-table entry cleared during the
> + * unmapping operation and the reference count for the page-table page
> + * containing the cleared entry is decremented, with unreferenced pages being
> + * freed. The unmapping operation will stop early if it encounters either an
> + * invalid page-table entry or a valid block mapping which maps beyond the range
> + * being unmapped.

How is the caller expected to break up the block mapping? Why not
handle that within this function?

>
> + *
> + * Return: Number of bytes unmapped, which may be 0.
> + */
> +u64 kvm_pgtable_hyp_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size);
> +
>  /**
>   * kvm_get_vtcr() - Helper to construct VTCR_EL2
>   * @mmfr0:     Sanitized value of SYS_ID_AA64MMFR0_EL1 register.
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 768a58835153..6ad4cb2d6947 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -463,6 +463,69 @@ int kvm_pgtable_hyp_map(struct kvm_pgtable *pgt, u64 addr, u64 size, u64 phys,
>         return ret;
>  }
>
> +struct hyp_unmap_data {
> +       u64                             unmapped;
> +       struct kvm_pgtable_mm_ops       *mm_ops;
> +};
> +
> +static int hyp_unmap_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
> +                           enum kvm_pgtable_walk_flags flag, void * const arg)
> +{
> +       kvm_pte_t pte = *ptep, *childp = NULL;
> +       u64 granule = kvm_granule_size(level);
> +       struct hyp_unmap_data *data = arg;
> +       struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
> +
> +       if (!kvm_pte_valid(pte))
> +               return -EINVAL;
> +
> +       if (kvm_pte_table(pte, level)) {
> +               childp = kvm_pte_follow(pte, mm_ops);
> +
> +               if (mm_ops->page_count(childp) != 1)
> +                       return 0;
> +
> +               kvm_clear_pte(ptep);
> +               dsb(ishst);
> +               __tlbi_level(vae2is, __TLBI_VADDR(addr, 0), level);
> +       } else {
> +               if (end - addr < granule)
> +                       return -EINVAL;
> +
> +               kvm_clear_pte(ptep);
> +               dsb(ishst);
> +               __tlbi_level(vale2is, __TLBI_VADDR(addr, 0), level);
> +               data->unmapped += granule;
> +       }
> +
> +       dsb(ish);
> +       isb();
> +       mm_ops->put_page(ptep);
> +
> +       if (childp)
> +               mm_ops->put_page(childp);
> +
> +       return 0;
> +}
> +
> +u64 kvm_pgtable_hyp_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size)
> +{
> +       struct hyp_unmap_data unmap_data = {
> +               .mm_ops = pgt->mm_ops,
> +       };
> +       struct kvm_pgtable_walker walker = {
> +               .cb     = hyp_unmap_walker,
> +               .arg    = &unmap_data,
> +               .flags  = KVM_PGTABLE_WALK_LEAF | KVM_PGTABLE_WALK_TABLE_POST,
> +       };
> +
> +       if (!pgt->mm_ops->page_count)
> +               return 0;
> +
> +       kvm_pgtable_walk(pgt, addr, size, &walker);
> +       return unmap_data.unmapped;
> +}
> +
>  int kvm_pgtable_hyp_init(struct kvm_pgtable *pgt, u32 va_bits,
>                          struct kvm_pgtable_mm_ops *mm_ops)
>  {
> --
> 2.34.0.rc2.393.gf8c9666880-goog
>
> --
> To unsubscribe from this group and stop receiving emails from it, send an email to kernel-team+unsubscribe@android.com.
>

--000000000000ca51d505d28f73d8
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIIPmgYJKoZIhvcNAQcCoIIPizCCD4cCAQExDzANBglghkgBZQMEAgEFADALBgkqhkiG9w0BBwGg
ggz0MIIEtjCCA56gAwIBAgIQeAMYYHb81ngUVR0WyMTzqzANBgkqhkiG9w0BAQsFADBMMSAwHgYD
VQQLExdHbG9iYWxTaWduIFJvb3QgQ0EgLSBSMzETMBEGA1UEChMKR2xvYmFsU2lnbjETMBEGA1UE
AxMKR2xvYmFsU2lnbjAeFw0yMDA3MjgwMDAwMDBaFw0yOTAzMTgwMDAwMDBaMFQxCzAJBgNVBAYT
AkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMSowKAYDVQQDEyFHbG9iYWxTaWduIEF0bGFz
IFIzIFNNSU1FIENBIDIwMjAwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCvLe9xPU9W
dpiHLAvX7kFnaFZPuJLey7LYaMO8P/xSngB9IN73mVc7YiLov12Fekdtn5kL8PjmDBEvTYmWsuQS
6VBo3vdlqqXZ0M9eMkjcKqijrmDRleudEoPDzTumwQ18VB/3I+vbN039HIaRQ5x+NHGiPHVfk6Rx
c6KAbYceyeqqfuJEcq23vhTdium/Bf5hHqYUhuJwnBQ+dAUcFndUKMJrth6lHeoifkbw2bv81zxJ
I9cvIy516+oUekqiSFGfzAqByv41OrgLV4fLGCDH3yRh1tj7EtV3l2TngqtrDLUs5R+sWIItPa/4
AJXB1Q3nGNl2tNjVpcSn0uJ7aFPbAgMBAAGjggGKMIIBhjAOBgNVHQ8BAf8EBAMCAYYwHQYDVR0l
BBYwFAYIKwYBBQUHAwIGCCsGAQUFBwMEMBIGA1UdEwEB/wQIMAYBAf8CAQAwHQYDVR0OBBYEFHzM
CmjXouseLHIb0c1dlW+N+/JjMB8GA1UdIwQYMBaAFI/wS3+oLkUkrk1Q+mOai97i3Ru8MHsGCCsG
AQUFBwEBBG8wbTAuBggrBgEFBQcwAYYiaHR0cDovL29jc3AyLmdsb2JhbHNpZ24uY29tL3Jvb3Ry
MzA7BggrBgEFBQcwAoYvaHR0cDovL3NlY3VyZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvcm9vdC1y
My5jcnQwNgYDVR0fBC8wLTAroCmgJ4YlaHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9yb290LXIz
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
qd3u9nMPvaXsVbwMPzBMBgNVHSAERTBDMEEGCSsGAQQBoDIBKDA0MDIGCCsGAQUFBwIBFiZodHRw
czovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzAJBgNVHRMEAjAAMIGaBggrBgEFBQcB
AQSBjTCBijA+BggrBgEFBQcwAYYyaHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vY2EvZ3NhdGxh
c3Izc21pbWVjYTIwMjAwSAYIKwYBBQUHMAKGPGh0dHA6Ly9zZWN1cmUuZ2xvYmFsc2lnbi5jb20v
Y2FjZXJ0L2dzYXRsYXNyM3NtaW1lY2EyMDIwLmNydDAfBgNVHSMEGDAWgBR8zApo16LrHixyG9HN
XZVvjfvyYzBGBgNVHR8EPzA9MDugOaA3hjVodHRwOi8vY3JsLmdsb2JhbHNpZ24uY29tL2NhL2dz
YXRsYXNyM3NtaW1lY2EyMDIwLmNybDANBgkqhkiG9w0BAQsFAAOCAQEAajBIqjTLb65loo5f300X
u7oe5++cidgOWlobHh9CIwYzejSGdBw2VEAGnTqKEqTftoGHiEobnRbz0YibhaeI6myx1ANKPUmG
ISl47qlazJAZoqPc+iofgNOSv10xcLSSPjbxqLBlB4iV7vkgwha+26s9IXRRQzxnKHFsrCuxNkPd
Yea60MlnfbCnQkhesEYvI9zZyIezhJnKAvKSBcUGt/V3q4EH8RhIokrnclLU4qggjwkbozVwiREO
Z7RKIVS3OOrJoGNqZCyc/Ofg33pvfy8UgConrY7dlccLZOH9GJ/krmwAp9Sr0SZhLxgCfSXbReaf
FT6N00mzsDKwf3N9GjGCAmowggJmAgEBMGgwVDELMAkGA1UEBhMCQkUxGTAXBgNVBAoTEEdsb2Jh
bFNpZ24gbnYtc2ExKjAoBgNVBAMTIUdsb2JhbFNpZ24gQXRsYXMgUjMgU01JTUUgQ0EgMjAyMAIQ
Ae+7eLPFqETXFnZkWuTFajANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQgUZF1cPnv
o4ckEGxcL2rEemgu/6sHZb9mH1nZcJiVTPwwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkq
hkiG9w0BCQUxDxcNMjExMjA3MTQ0NzI4WjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG
9w0BAQcwCwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAJP42r5b2+KGkFHrXRKH+maZUhsI
VzqqD8WtEXfApWcisCK0MBulPbvHLsJPN8JEFZMUYutb1RPDfiIXLN9l5CR1WymbapEoRw/+LyjE
g3HlnvFncNIFsiq5uIgWANRtKz19etTwPGqdHe3HEi9AVoS8WCZsH54CrvjufS0pXUlOeZ62xbB4
/3413cXq4BE9/N0muFGEEZaj+1OKqsXu3uQn+Oo/Ly2s9u7B8oNMvQ+CVuI1zPu6z4hL1SblRrMA
jlMxjYJQvMoG9qCa6vsv3zkBL24yPhx716DVg0SvNJAkM/pRsVoLglpEJrmlHZRMfq9+u6rWYosn
x+zYJ3NJ540=
--000000000000ca51d505d28f73d8--

--===============1056448663922424150==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============1056448663922424150==--
