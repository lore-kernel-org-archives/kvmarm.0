Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A19A37B
	for <kvmarm@lists.linux.dev>; Tue, 25 Apr 2023 00:54:44 +0000 (UTC)
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-63b5c48ea09so4392584b3a.1
        for <kvmarm@lists.linux.dev>; Mon, 24 Apr 2023 17:54:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682384084; x=1684976084;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TvC05ourDb/+RUYOByG9ySrV1Ngi2eY5g+3zE7Tf+nM=;
        b=asdFIRONALlkoBpiH3qHNZl6Er6plYAVOFybVacPKhNsz6YTtO5vT44uu5E4SmUtKw
         5gbA1Wilb96HOar5xMDrQnm1swfyNOHs9RZkVOEupfsz9h9qCpd6TpIihK98c2HHhxXj
         Ph+zUC9gVVFQSmhCdl5ppNXGEb/Mzc0Vdtje590oVVaA/tbPpV+4jGXBschtimnb0eUg
         V+m7VeaskReeS64KrVtZxWenhG4DwM/DTPw4Cll4LpJUy/WRH4okOYt+/jhdr8Glc1HC
         hods9UkzE791IpXlorsOiwRBSoWgNC5kWpWaHr83WR1Uis8Wpu1mTXTBkFTRen8bPDgM
         oOIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682384084; x=1684976084;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TvC05ourDb/+RUYOByG9ySrV1Ngi2eY5g+3zE7Tf+nM=;
        b=OgwE4Y/TYKV/yOMjlmRZfCX/L7XOago2I1jXYfunCK2kedLKKES5Kv86E1fhRfHn2N
         ZAJB48cBqorr8RblYTr4gL58NgjLlAp+SGy23t7y+U7mRKjAHTV0KDcEnCVmROsaKTJv
         zxV47DN8cyaaJoBSQB9ZdOq1STH0sGJYXpk9aP/rtKp30Nt3a7guwPB+uavZ6oPsQVPr
         1/ZgsPE+W02RKW9TyuwTxrjY0pwo8/okOhIj+azgi162tlxE7lK5Mhx5CjSKmM9zUQLk
         mFAVWOovym7lcDmymHYrC/LaWCrLgcrDofXrb6/BF1wxK+G5ZpJHvqY+cd95wpzFfMjd
         l9Jg==
X-Gm-Message-State: AAQBX9dkiZndTsxlLSMYiAnMlMKSPMANM+wOmqyfGoVQC26U9XKB1LAe
	akp1IlpEHVsGjki+aQuwCMs=
X-Google-Smtp-Source: AKy350aSyH3YhqmD53aiAH71E3BbzLDAuKTQPSESJBaOwVS4DnTIKqlin7/LKOAc5uLmrPP75dU7fg==
X-Received: by 2002:a05:6a00:2e0c:b0:63d:4920:c101 with SMTP id fc12-20020a056a002e0c00b0063d4920c101mr21392456pfb.30.1682384083786;
        Mon, 24 Apr 2023 17:54:43 -0700 (PDT)
Received: from smtpclient.apple ([66.170.99.2])
        by smtp.gmail.com with ESMTPSA id i189-20020a62c1c6000000b005a8b28c644esm7983952pfg.4.2023.04.24.17.54.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Apr 2023 17:54:43 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.500.231\))
Subject: Re: [PATCH v3 00/22] Improve scalability of KVM + userfaultfd live
 migration via annotated memory faults.
From: Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <CAF7b7mr-_U6vU1iOwukdmOoaT0G1ttyxD62cv=vebnQeXL3R0w@mail.gmail.com>
Date: Mon, 24 Apr 2023 17:54:31 -0700
Cc: Peter Xu <peterx@redhat.com>,
 Axel Rasmussen <axelrasmussen@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 maz@kernel.org,
 oliver.upton@linux.dev,
 Sean Christopherson <seanjc@google.com>,
 James Houghton <jthoughton@google.com>,
 bgardon@google.com,
 dmatlack@google.com,
 ricarkol@google.com,
 kvm <kvm@vger.kernel.org>,
 kvmarm@lists.linux.dev
Content-Transfer-Encoding: quoted-printable
Message-Id: <307D798E-9135-41F7-80C7-1E0758259F95@gmail.com>
References: <20230412213510.1220557-1-amoorthy@google.com>
 <ZEBHTw3+DcAnPc37@x1n>
 <CAJHvVchBqQ8iVHgF9cVZDusMKQM2AjtNx2z=i9ZHP2BosN4tBg@mail.gmail.com>
 <ZEBXi5tZZNxA+jRs@x1n>
 <CAF7b7mo68VLNp=QynfT7QKgdq=d1YYGv1SEVEDxF9UwHzF6YDw@mail.gmail.com>
 <ZEGuogfbtxPNUq7t@x1n> <46DD705B-3A3F-438E-A5B1-929C1E43D11F@gmail.com>
 <CAF7b7mo78e2YPHU5YrhzuORdpGXCVRxXr6kSyMa+L+guW8jKGw@mail.gmail.com>
 <84DD9212-31FB-4AF6-80DD-9BA5AEA0EC1A@gmail.com>
 <CAF7b7mr-_U6vU1iOwukdmOoaT0G1ttyxD62cv=vebnQeXL3R0w@mail.gmail.com>
To: Anish Moorthy <amoorthy@google.com>
X-Mailer: Apple Mail (2.3731.500.231)



> On Apr 24, 2023, at 5:15 PM, Anish Moorthy <amoorthy@google.com> =
wrote:
>=20
> On Mon, Apr 24, 2023 at 12:44=E2=80=AFPM Nadav Amit =
<nadav.amit@gmail.com> wrote:
>>=20
>>=20
>>=20
>>> On Apr 24, 2023, at 10:54 AM, Anish Moorthy <amoorthy@google.com> =
wrote:
>>>=20
>>> On Fri, Apr 21, 2023 at 10:40=E2=80=AFAM Nadav Amit =
<nadav.amit@gmail.com> wrote:
>>>>=20
>>>> If I understand the problem correctly, it sounds as if the proper =
solution
>>>> should be some kind of a range-locks. If it is too heavy or the =
interface can
>>>> be changed/extended to wake a single address (instead of a range),
>>>> simpler hashed-locks can be used.
>>>=20
>>> Some sort of range-based locking system does seem relevant, although =
I
>>> don't see how that would necessarily speed up the delivery of faults
>>> to UFFD readers: I'll have to think about it more.
>>=20
>> Perhaps I misread your issue. Based on the scalability issues you =
raised,
>> I assumed that the problem you encountered is related to lock =
contention.
>> I do not know whether your profiled it, but some information would be
>> useful.
>=20
> No, you had it right: the issue at hand is contention on the uffd wait
> queues. I'm just not sure what the range-based locking would really be
> doing. Events would still have to be delivered to userspace in an
> ordered manner, so it seems to me that each uffd would still need to
> maintain a queue (and the associated contention).

There are 2 queues. One for the pending faults that were still not =
reported
to userspace, and one for the faults that we might need to wake up. The =
second
one can have range locks.

Perhaps some hybrid approach would be best: do not block on page-faults =
that
KVM runs into, which would prevent you from the need to enqueue on =
fault_wqh.

But I do not know whether the reporting through KVM instead of=20
userfaultfd-based mechanism is very clean. I think that an IO-uring =
based
solution, such as the one I proposed before, would be more generic. =
Actually,
now that I understand better your use-case, you do not need a core to =
poll
and you would just be able to read the page-fault information from the =
IO-uring.

Then, you can report whether the page-fault blocked or not in a flag.

>=20
> With respect to the "sharding" idea, I collected some more runs of the
> self test (full command in [1]). This time I omitted the "-a" flag, so
> that every vCPU accesses a different range of guest memory with its
> own UFFD, and set the number of reader threads per UFFD to 1.

Just wondering, did you run the benchmark with DONTWAKE? Sounds as if =
the
wake is not needed.

