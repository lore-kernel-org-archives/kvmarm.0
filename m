Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 587B64C99
	for <kvmarm@lists.linux.dev>; Fri,  5 May 2023 20:05:16 +0000 (UTC)
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-643557840e4so2532294b3a.2
        for <kvmarm@lists.linux.dev>; Fri, 05 May 2023 13:05:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683317116; x=1685909116;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=te4sAuRzX8wSQKX6THFhQ+UogT5JHUxdicm0nlSOK7Q=;
        b=hTJkx1aBQ3X/ggwMdGwfrocXkNybdm6YFEepVzFvEYp/joksyFqSeT9n3c4irIW6wn
         lfA3hEGHF2+hDGGh7vlC03BiqVO5xNHOSzAJjvJ841sp0JmwikTvShH3zpyQYLbWjQIv
         rAUo05ZVovtWF5lmOOEe6JGJ+cfgS+6OqZQNk0EJGf9/8aE3KH+fXdGVL/IZzmD/3RkU
         WCDBWHaLUa8C7mrSSwDr/hEui2G5B7MteIpTLgAqV9wvTN5fymw0v1PjHgVaL3mlYEwY
         HWrR/kQ3fA0LPS+TKDohl7M6xOpwg9yKvykzgcSbwExNguOmb5UVyG8ewd8jiiuesC70
         7MXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683317116; x=1685909116;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=te4sAuRzX8wSQKX6THFhQ+UogT5JHUxdicm0nlSOK7Q=;
        b=LZngyfD/B7QR/tBx5ogkz9Q6cFbYhSKTKgMAm3HEfwEwTSAtEh5VM8aXn0ThKikX00
         Hp8A8hgMR09UL2FR8k/5UYT8fk95hkumKWUS08cih2gdajvvwcEb1scZiv3Avhraz52E
         BFSlNY7LG+wX+hkVv0izpqOOIog1SzAckoO1Kd1PT2zUYRg/DR0G+Mut7qd3C4W+6M82
         y/c6zp7+YDOZBI/1hQDE+c3qV86ZxQIOIUMyFuMeC/+nIyEC4TBuarRUluPo3YVWV9EY
         yU6XoCpMxlk/f+ZDGmI+qMEqYt7yUIPSHef+H26eOtHOi1CbhWLEukVan4KBMkX/OS/k
         Pj/Q==
X-Gm-Message-State: AC+VfDyFp90gOHKnmV8TwSDxUI2EoOfU3A94pWiKJJuAzCJHoEIcmw+V
	vYaKD1W+sMOujFGdle1d5Yc=
X-Google-Smtp-Source: ACHHUZ75P0u2CxseiLnXqvon8NR428DDVfkd9GBfbjK16rQnl2L1ovsA78wH6CgK7aGsUzIghW9K/Q==
X-Received: by 2002:a05:6a20:d39b:b0:f6:c920:7870 with SMTP id iq27-20020a056a20d39b00b000f6c9207870mr2724178pzb.59.1683317115161;
        Fri, 05 May 2023 13:05:15 -0700 (PDT)
Received: from smtpclient.apple ([66.170.99.2])
        by smtp.gmail.com with ESMTPSA id v16-20020aa78510000000b005a8de0f4c64sm1988708pfn.82.2023.05.05.13.05.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 May 2023 13:05:14 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.500.231\))
Subject: Re: [PATCH v3 00/22] Improve scalability of KVM + userfaultfd live
 migration via annotated memory faults.
From: Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <ZFLyGDoXHQrN1CCD@x1n>
Date: Fri, 5 May 2023 13:05:02 -0700
Cc: Sean Christopherson <seanjc@google.com>,
 Anish Moorthy <amoorthy@google.com>,
 Axel Rasmussen <axelrasmussen@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 maz@kernel.org,
 oliver.upton@linux.dev,
 James Houghton <jthoughton@google.com>,
 bgardon@google.com,
 dmatlack@google.com,
 ricarkol@google.com,
 kvm <kvm@vger.kernel.org>,
 kvmarm@lists.linux.dev
Content-Transfer-Encoding: quoted-printable
Message-Id: <8ED96522-B4A5-4106-B30B-8BE635B5DA7A@gmail.com>
References: <ZEGuogfbtxPNUq7t@x1n>
 <46DD705B-3A3F-438E-A5B1-929C1E43D11F@gmail.com>
 <CAF7b7mo78e2YPHU5YrhzuORdpGXCVRxXr6kSyMa+L+guW8jKGw@mail.gmail.com>
 <84DD9212-31FB-4AF6-80DD-9BA5AEA0EC1A@gmail.com>
 <CAF7b7mr-_U6vU1iOwukdmOoaT0G1ttyxD62cv=vebnQeXL3R0w@mail.gmail.com>
 <ZErahL/7DKimG+46@x1n>
 <CAF7b7mqaxk6w90+9+5UkEAE13vDTmBMmCO_ZdAEo6pD8_--fZA@mail.gmail.com>
 <ZFLPlRReglM/Vgfu@x1n> <ZFLRpEV09lrpJqua@x1n> <ZFLVS+UvpG5w747u@google.com>
 <ZFLyGDoXHQrN1CCD@x1n>
To: Peter Xu <peterx@redhat.com>
X-Mailer: Apple Mail (2.3731.500.231)



> On May 3, 2023, at 4:45 PM, Peter Xu <peterx@redhat.com> wrote:
>=20
> On Wed, May 03, 2023 at 02:42:35PM -0700, Sean Christopherson wrote:
>> On Wed, May 03, 2023, Peter Xu wrote:
>>> Oops, bounced back from the list..
>>>=20
>>> Forward with no attachment this time - I assume the information is =
still
>>> enough in the paragraphs even without the flamegraphs.
>>=20
>> The flamegraphs are definitely useful beyond what is captured here.  =
Not sure
>> how to get them accepted on the list though.
>=20
> Trying again with google drive:
>=20
> single uffd:
> https://drive.google.com/file/d/1bYVYefIRRkW8oViRbYv_HyX5Zf81p3Jl/view
>=20
> 32 uffds:
> https://drive.google.com/file/d/1T19yTEKKhbjU9G2FpANIvArSC61mqqtp/view
>=20
>>=20
>>>> =46rom what I got there, vmx_vcpu_load() gets more highlights than =
the
>>>> spinlocks. I think that's the tlb flush broadcast.
>>=20
>> No, it's KVM dealing with the vCPU being migrated to a different =
pCPU.  The
>> smp_call_function_single() that shows up is from loaded_vmcs_clear() =
and is
>> triggered when KVM needs to VMCLEAR the VMCS on the _previous_ pCPU =
(yay for the
>> VMCS caches not being coherent).
>>=20
>> Task migration can also trigger IBPB (if mitigations are enabled), =
and also does
>> an "all contexts" INVEPT, i.e. flushes all TLB entries for KVM's MMU.
>>=20
>> Can you trying 1:1 pinning of vCPUs to pCPUs?  That _should_ =
eliminate the
>> vmx_vcpu_load_vmcs() hotspot, and for large VMs is likely =
represenative of a real
>> world configuration.
>=20
> Yes it does went away:
>=20
> https://drive.google.com/file/d/1ZFhWnWjoU33Lxy43jTYnKFuluo4zZArm/view
>=20
> With pinning vcpu threads only (again, over 40 hard cores/threads):
>=20
> ./demand_paging_test -b 512M -u MINOR -s shmem -v 32 -c =
1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28=
,29,30,31,32
>=20
> It seems to me for some reason the scheduler ate more than I =
expected..
> Maybe tomorrow I can try two more things:
>=20
>  - Do cpu isolations, and
>  - pin reader threads too (or just leave the readers on housekeeping =
cores)

For the record (and I hope I do not repeat myself): these scheduler =
overheads
is something that I have encountered before.

The two main solutions I tried were:

1. Optional polling on the faulting thread to avoid context switch on =
the
   faulting thread.

(something like =
https://lore.kernel.org/linux-mm/20201129004548.1619714-6-namit@vmware.com=
/ )

and=20

2. IO-uring to avoid context switch on the handler thread.

In addition, as I mentioned before, the queue locks is something that =
can be
simplified.

