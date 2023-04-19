Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF98DD2E4
	for <kvmarm@lists.linux.dev>; Wed, 19 Apr 2023 20:16:22 +0000 (UTC)
Received: by mail-lj1-f172.google.com with SMTP id h2so246727ljh.13
        for <kvmarm@lists.linux.dev>; Wed, 19 Apr 2023 13:16:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681935381; x=1684527381;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wRtalYFerwmw+OfWqRHaDlMXdJ7bPKZ2DC5Ux2SX7bk=;
        b=ZpPTB5sEUEIXZMe6tZZo1OfRBcRYN8rWCYtnuywY4w9BEdpriIZEFQB+aBDJJEA/3O
         /LAWUUZtLhycv74Xfnwy6aKSCUMU/PrakTiEtneG20KwCnnihflcriJ3e2aUo+ynXjP4
         qe1W/N01rFFrNkc6VKwSAKBReovz6typFgrlAxnIuE9+qfT/fk8pwD7qFeTq+Oc8RyyV
         Mg9a4saGfQVIH6k8lhjL3V24VUsokjsuUtsv9Mx848aW+ozSP1aY3JnmGyR9XGKcQnci
         EGAl1+tfUotT52TnsC1cUv1lq+U96CNb/l0tzOYVFbeCr6u+T3k6x85e1wumu4sFWOom
         i+pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681935381; x=1684527381;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wRtalYFerwmw+OfWqRHaDlMXdJ7bPKZ2DC5Ux2SX7bk=;
        b=LBvfdNguETekmZF18TdInVs/mLUcCoZUAiF0mJKSxqBQp/aqcRV0Kfx6xp4eBqfoDL
         GMIPW7aLJTYkA6bqShfuLl7gBPIpI1EGSUv8Dmphs7u1Lk6rI+lKg4rSzB7wsmCYIGFc
         9mIF8jGPiSy40VdK1MPtBEPL5yDjELIMewBDb2lFRAk3km+GrZKjgpYvgKFJb5zyxzCv
         JFKewIUlzaB0RpHmaNQpnNXUNmxYTr5Cd9/uW8DhePjZVi6vJ4TfgjYeSsVV91E174JD
         fGsyI9VNt7i8QefbL7KbhxEdkEJrZJmLC9S8igTc18B2t18jgzMh2Tf5snFxWRYee+Ax
         OMNg==
X-Gm-Message-State: AAQBX9cD+h3Jokz1UFuepcHCpUiE+5krjPoN2AGZAbfpm6/arfyRcbrE
	VxvgEwUMPIkL91nYdM223NLaZ5RpxVzrx7T/Xek8vA==
X-Google-Smtp-Source: AKy350a61cd30/1k5ScgIWz3PotN3G1jxvViqqtdGsP/m0LPV2TMsOkaGYsESWdlgcba+fmv1IJrcksdAj5636iC7/0=
X-Received: by 2002:a05:651c:10e:b0:29d:d0b:7a78 with SMTP id
 a14-20020a05651c010e00b0029d0d0b7a78mr2460294ljb.21.1681935380656; Wed, 19
 Apr 2023 13:16:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230412213510.1220557-1-amoorthy@google.com> <ZEBHTw3+DcAnPc37@x1n>
In-Reply-To: <ZEBHTw3+DcAnPc37@x1n>
From: Axel Rasmussen <axelrasmussen@google.com>
Date: Wed, 19 Apr 2023 13:15:44 -0700
Message-ID: <CAJHvVchBqQ8iVHgF9cVZDusMKQM2AjtNx2z=i9ZHP2BosN4tBg@mail.gmail.com>
Subject: Re: [PATCH v3 00/22] Improve scalability of KVM + userfaultfd live
 migration via annotated memory faults.
To: Peter Xu <peterx@redhat.com>
Cc: Anish Moorthy <amoorthy@google.com>, pbonzini@redhat.com, maz@kernel.org, 
	oliver.upton@linux.dev, seanjc@google.com, jthoughton@google.com, 
	bgardon@google.com, dmatlack@google.com, ricarkol@google.com, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 19, 2023 at 12:56=E2=80=AFPM Peter Xu <peterx@redhat.com> wrote=
:
>
> Hi, Anish,
>
> On Wed, Apr 12, 2023 at 09:34:48PM +0000, Anish Moorthy wrote:
> > KVM's demand paging self test is extended to demonstrate the performanc=
e
> > benefits of using the two new capabilities to bypass the userfaultfd
> > wait queue. The performance samples below (rates in thousands of
> > pages/s, n =3D 5), were generated using [2] on an x86 machine with 256
> > cores.
> >
> > vCPUs, Average Paging Rate (w/o new caps), Average Paging Rate (w/ new =
caps)
> > 1       150     340
> > 2       191     477
> > 4       210     809
> > 8       155     1239
> > 16      130     1595
> > 32      108     2299
> > 64      86      3482
> > 128     62      4134
> > 256     36      4012
>
> The number looks very promising.  Though..
>
> >
> > [1] https://lore.kernel.org/linux-mm/CADrL8HVDB3u2EOhXHCrAgJNLwHkj2Lka1=
B_kkNb0dNwiWiAN_Q@mail.gmail.com/
> > [2] ./demand_paging_test -b 64M -u MINOR -s shmem -a -v <n> -r <n> [-w]
> >     A quick rundown of the new flags (also detailed in later commits)
> >         -a registers all of guest memory to a single uffd.
>
> ... this is the worst case scenario.  I'd say it's slightly unfair to
> compare by first introducing a bottleneck then compare with it. :)
>
> Jokes aside: I'd think it'll make more sense if such a performance soluti=
on
> will be measured on real systems showing real benefits, because so far it=
's
> still not convincing enough if it's only with the test especially with on=
ly
> one uffd.
>
> I don't remember whether I used to discuss this with James before, but..
>
> I know that having multiple uffds in productions also means scattered gue=
st
> memory and scattered VMAs all over the place.  However split the guest
> large mem into at least a few (or even tens of) VMAs may still be somethi=
ng
> worth trying?  Do you think that'll already solve some of the contentions
> on userfaultfd, either on the queue or else?

We considered sharding into several UFFDs. I do think it helps, but
also I think there are two main problems with it:

- One is, I think there's a limit to how much you'd want to do that.
E.g. splitting guest memory in 1/2, or in 1/10, could be reasonable,
but 1/100 or 1/1000 might become ridiculous in terms of the
"scattering" of VMAs and so on like you mentioned. Especially for very
large VMs (e.g. consider Google offers VMs with ~11T of RAM [1]) I'm
not sure splitting just "slightly" is enough to get good performance.

- Another is, sharding UFFDs sort of assumes accesses are randomly
distributed across the guest physical address space. I'm not sure this
is guaranteed for all possible VMs / customer workloads. In other
words, even if we shard across several UFFDs, we may end up with a
small number of them being "hot".

A benefit to Anish's series is that it solves the problem more
fundamentally, and allows demand paging with no "global" locking. So,
it will scale better regardless of VM size, or access pattern.

[1]: https://cloud.google.com/compute/docs/memory-optimized-machines

>
> With a bunch of VMAs and userfaultfds (paired with uffd fault handler
> threads, totally separate uffd queues), I'd expect to some extend other
> things can pop up already, e.g., the network bandwidth, without teaching
> each vcpu thread to report uffd faults themselves.
>
> These are my pure imaginations though, I think that's also why it'll be
> great if such a solution can be tested more or less on a real migration
> scenario to show its real benefits.

I wonder, is there an existing open source QEMU/KVM based live
migration stress test?

I think we could share numbers from some of our internal benchmarks,
or at the very least give relative numbers (e.g. +50% increase), but
since a lot of the software stack is proprietary (e.g. we don't use
QEMU), it may not be that useful or reproducible for folks.

>
> Thanks,
>
> --
> Peter Xu
>
