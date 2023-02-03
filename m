Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AF4A1FB9
	for <kvmarm@lists.linux.dev>; Fri,  3 Feb 2023 10:16:55 +0000 (UTC)
Received: by mail-pj1-f43.google.com with SMTP id n20-20020a17090aab9400b00229ca6a4636so8387009pjq.0
        for <kvmarm@lists.linux.dev>; Fri, 03 Feb 2023 02:16:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0ZbAUGn0r6doN6zThP1Zquzlxw14avp8efmj05+Io/4=;
        b=Ywh4mnPVN3Y4k0f4DuulkG2miIzAXD2MOag6AoE9aqI4lk2/oCohsrtf8Gr8EPviVM
         w5YHMEJEeyxv4Kxv5i6v3b/lUpqXFNx1osYHGwcvd5Y6A4ASt/XYopzNc7ULMCnsOI6d
         IrSWoKHqFH3ZA9JFOpulvON/sgxK8lIDCGcFdofh7TQct/4Basch9lONK7Jz9jH6b2l5
         lG9ZdPMIFHQYLtBy4nRdrdwKqfTKG98jS03kSpv/G7uTjB62apnvK8P8uUgwZxEBoWt6
         TcPvwy+n7no1gkpCj3JC/uJM6ahYRPgSN0IO8wEZNDBK6v4Lg/AjhsnsKmGHKgxXIauL
         JR8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=0ZbAUGn0r6doN6zThP1Zquzlxw14avp8efmj05+Io/4=;
        b=kC+C8gX9C64dC/XPbahchSt3s5CFyHxEzpx6mxPNdZxx7BI778eL8IyFWruVIu5N1W
         UjgZQmTeSU2LHxjFLJrdUfKF+ZwUzuLqnNSY219FNscLelnlKHAJ6dcmmjPEezmkAyk4
         TbvYcoH/V41eovgDBJ87UIMqBSE2Eqw4v/Z3/uMVMf1NSRQyu9dN/EtwOJ3+k5/6Zy/p
         vhwQbFB3yW78LQaxa2gBaPaq2QHLvtVQw1ndVkxPRj0SBoSyGbgClFFSBRWd7bnFSTV6
         HdfXZtEReZ4l6v5wcNMLBHD4pE2Zad9BVELRtHWOdkwTGqKTJ0V/aNS1+N1fxiYCNUch
         YGww==
X-Gm-Message-State: AO0yUKUoPd7yeXkLTVCFfsLnP4oexzAJaB71X5z9ngXyNPPOAzhU3DJ3
	pkBCDPAfU/RZCYa07WgQThc=
X-Google-Smtp-Source: AK7set8WbQ1iPrN5HSlN4f706F1IqNht5RVf+MEFDgPYm7h/efSiL2BKY4uYWAK+N6jAmo/6Qh0viw==
X-Received: by 2002:a17:902:da92:b0:196:5839:b36a with SMTP id j18-20020a170902da9200b001965839b36amr11622683plx.8.1675419414829;
        Fri, 03 Feb 2023 02:16:54 -0800 (PST)
Received: from localhost (193-116-117-77.tpgi.com.au. [193.116.117.77])
        by smtp.gmail.com with ESMTPSA id n19-20020a170902969300b00198e03c3ad4sm1002403plp.278.2023.02.03.02.16.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Feb 2023 02:16:54 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 03 Feb 2023 20:16:45 +1000
Message-Id: <CQ8UM1FTPEUZ.3F2RONR3AJ5YP@bobo>
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Thomas Huth" <thuth@redhat.com>, <kvm@vger.kernel.org>, "Paolo Bonzini"
 <pbonzini@redhat.com>, "Sean Christopherson" <seanjc@google.com>
Cc: "Claudio Imbrenda" <imbrenda@linux.ibm.com>, "Janosch Frank"
 <frankja@linux.ibm.com>, "Suzuki K Poulose" <suzuki.poulose@arm.com>, "Marc
 Zyngier" <maz@kernel.org>, "David Hildenbrand" <david@redhat.com>,
 <linux-kernel@vger.kernel.org>, "Oliver Upton" <oliver.upton@linux.dev>,
 "Zenghui Yu" <yuzenghui@huawei.com>, "James Morse" <james.morse@arm.com>,
 <kvm-riscv@lists.infradead.org>, <kvmarm@lists.linux.dev>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH 3/7] KVM: Move KVM_GET_NR_MMU_PAGES into the deprecation
 section
X-Mailer: aerc 0.13.0
References: <20230203094230.266952-1-thuth@redhat.com>
 <20230203094230.266952-4-thuth@redhat.com>
In-Reply-To: <20230203094230.266952-4-thuth@redhat.com>

On Fri Feb 3, 2023 at 7:42 PM AEST, Thomas Huth wrote:
> The KVM_GET_NR_MMU_PAGES ioctl is quite questionable on 64-bit hosts
> since it fails to return the full 64 bits of the value that can be
> set with the corresponding KVM_SET_NR_MMU_PAGES call. This ioctl
> likely has also never really been used by userspace applications
> (at least not by QEMU and kvmtool which I checked), so it's better
> to move it to the deprecation section in kvm.h to make it clear for
> developers that this also should not be used in new code in the
> future anymore.

Did this get included in the series inadvertently?

Thanks,
Nick

>
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>  include/uapi/linux/kvm.h | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 55155e262646..f55965a4cec7 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -83,6 +83,8 @@ struct kvm_debug_guest {
> =20
>  #define __KVM_DEPRECATED_VCPU_W_0x87 _IOW(KVMIO, 0x87, struct kvm_debug_=
guest)
> =20
> +#define KVM_GET_NR_MMU_PAGES _IO(KVMIO, 0x45)
> +
>  /* *** End of deprecated interfaces *** */
> =20
> =20
> @@ -1442,7 +1444,6 @@ struct kvm_vfio_spapr_tce {
>  #define KVM_CREATE_VCPU           _IO(KVMIO,   0x41)
>  #define KVM_GET_DIRTY_LOG         _IOW(KVMIO,  0x42, struct kvm_dirty_lo=
g)
>  #define KVM_SET_NR_MMU_PAGES      _IO(KVMIO,   0x44)
> -#define KVM_GET_NR_MMU_PAGES      _IO(KVMIO,   0x45)
>  #define KVM_SET_USER_MEMORY_REGION _IOW(KVMIO, 0x46, \
>  					struct kvm_userspace_memory_region)
>  #define KVM_SET_TSS_ADDR          _IO(KVMIO,   0x47)
> --=20
> 2.31.1

