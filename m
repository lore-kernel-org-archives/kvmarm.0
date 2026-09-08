Received: from mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9516D3AE1A8
	for <kvmarm@lists.linux.dev>; Tue,  8 Sep 2026 08:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788854936; cv=none; b=gIS/T0rClIjsKLwdmiq6yhSLEKu/Cr229kZNFWKyiwfqK6+gywrBBSgNCXhmx+wz10N3zhR9KsITyJ5oeQp7Q7iO6eCiOwL5Dytqyqg3P7Di8ID1jSIHNIo8/SqQ/jXUCU0zhZzvGwn7jz9WFRnwa6l8MlOKRHuL3EI8RfabOLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788854936; c=relaxed/simple;
	bh=XGg4zKBZIdsYlLMLs2Et22MQ6qSUt/Oz2PZF17USj98=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OUMch6oBGD+BtYXg9JTsu53DbO1S9Fax9stu96IKqZgg/JoydyOHBQpigXcOXNL767oMFVzaYBSK9Xxv4LMh5pTOaglH82uWCh1mXSFFNTDItCCMuYtiBwVdVD0F53FxU5vb3lnotpp2DzU7uIcuGZe8mqOde7rrw0c/SqiT/5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Mlmo+YQs; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Mlmo+YQs"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=XGg4zKBZIdsYlLMLs2Et22MQ6qSUt/Oz2PZF17USj98=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788854932; v=1; x=1789459732;
 b=Mlmo+YQsRFmtBH5iYzY6FOWx307HAgCWIFqnTY3SM3f79Wo+uhZJbGYBJJI0IIs6JJRDFWIE
 GvbmGf932C2bm9c5GsIPm52hi6jijHdfhCoSQ9XzA0EjImPrJm8kIcLx7X+aeETjMZLoZrNVHmz
 TKnl30lHWPqdcJWfZ3e/NW4A=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id cfdab9a9098379f8;
	Tue, 08 Sep 2026 08:08:52 +0000
X-Mizu-Trace-ID: cfdab9a9098379f8
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf2-f12.google.com with SMTP id 2adb3069b0e04-5b4a0b17359so14293e87.0
        for <kvmarm@lists.linux.dev>; Tue, 08 Sep 2026 01:08:48 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwsH8WLbZ9TQjAIA3/rE0sgG0LBBG+Wz8xWD57y3S3m5dxQzgtfe4OkTBkajP6JIrWaXr7D2Ko=@lists.linux.dev
X-Gm-Message-State: AFuF++nZW/UYWUdQb3eM7/zCLICxIrvqfoBbg3WiFJCq3CCvz4f8wnLU
	UalpgX8r482j3yDRNyRKULsPFvtx5qkEawpTVNkzn/SdTQRE8Pc9aRDbsAHk1Eg0gXaI9ackb3h
	PbEv8zQRw2/YqVedO/oT84FxyJ6nWlfhEpW1edJZX
X-Received: by 2002:a05:6512:1344:b0:5b6:186e:682f with SMTP id
 2adb3069b0e04-5b751a5bf63mr134070e87.0.1788854927331; Tue, 08 Sep 2026
 01:08:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260826-arm64-52bit-va-v1-0-14ec98211363@fujitsu.com>
 <20260826-arm64-52bit-va-v1-2-14ec98211363@fujitsu.com> <CA+EHjTyJpPd8HjaWBw0V6pHF9UR0w2UFmaKDe7U3O+Sj8wiyPg@mail.gmail.com>
 <ap8rnTINMJQqfYGL@sm-arm-grace07>
In-Reply-To: <ap8rnTINMJQqfYGL@sm-arm-grace07>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 8 Sep 2026 09:08:11 +0100
X-Gmail-Original-Message-ID: <CA+EHjTwhoZEORBjJcUb1WQbFT1TtX8x=BeeMJAcdpEBVJJ265Q@mail.gmail.com>
X-Gm-Features: AcwNN1UAtKldnq8E5xQ_R8tgfkqEMJun_timebwDOYCwtGlMYwbA3T-yjMp633c
Message-ID: <CA+EHjTwhoZEORBjJcUb1WQbFT1TtX8x=BeeMJAcdpEBVJJ265Q@mail.gmail.com>
Subject: Re: [PATCH 2/2] KVM: selftests: arm64: Add 52-bit VA guest modes
To: Itaru Kitayama <itaru.kitayama@fujitsu.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Takayuki Okamoto <tokamoto@fujitsu.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, 7 Sept 2026 at 22:24, Itaru Kitayama <itaru.kitayama@fujitsu.com> wrote:
>
> Hi Fuad,
> On Fri, Sep 04, 2026 at 09:45:30AM +0100, Fuad Tabba wrote:
> > Hi Itaru,
> >
> > On Tue, 25 Aug 2026 at 22:18, Itaru Kitayama <itaru.kitayama@fujitsu.com> wrote:
> > ...
> > > diff --git a/tools/testing/selftests/kvm/lib/arm64/processor.c b/tools/testing/selftests/kvm/lib/arm64/processor.c
> > > index 9108e14a9b5b..bcdf670c9eb8 100644
> > > --- a/tools/testing/selftests/kvm/lib/arm64/processor.c
> > > +++ b/tools/testing/selftests/kvm/lib/arm64/processor.c
> > > @@ -46,7 +46,7 @@ static u64 pud_index(struct kvm_vm *vm, gva_t gva)
> > >         u64 mask = (1UL << (vm->page_shift - 3)) - 1;
> > >
> > >         TEST_ASSERT(vm->mmu.pgtable_levels >= 4,
> > > -                   "Mode %d does not have at least 4 page table levels",
> > > +                   "Mode %d does not have >= 4 page table levels",
> >
> > Patch 1 added this string one commit earlier. Could it go in with the
> > final wording there?
>
> Surely, will fix in v2.
>
> >
> > ...
> >
> > > @@ -298,10 +304,14 @@ struct kvm_vm *____vm_create(struct vm_shape shape)
> > >
> > >         /* Setup mode specific traits. */
> > >         switch (vm->mode) {
> > > +       case VM_MODE_P52V52_4K:
> > > +               vm->mmu.pgtable_levels = 5;
> > > +               break;
> >
> > This is now the deepest mode, so page_fault_test.c's sizing is stale:
> >
> >    * VM_MODE_P48V48_4K is the mode with most PT pages; let's use
> >    * twice that just in case.
> >   pt_size = 26 * guest_page_size;
> >
> > The margin still covers it. Could pt_size come from vm->mmu.pgtable_levels?
>
> I'm not the author of the page_fault_test.c for arm64, but so I'm
> guessing here; per the comment in the test, I dont think total number of
> levels determines pt_size, rather by the addresses prepared for the
> test.
>
> This stress test does not require high virtual addresses, though should
> we update the comment while at it?

You're right, pgtable_levels alone wouldn't capture it: what sizes
pt_size is the granule and how much the test maps, not the depth.

So just updating the comment is enough: name VM_MODE_P52V52_4K as the
deepest mode. At 5 levels it's the deepest any 4K mode uses, so the 2x
margin holds and the constant won't need revisiting.

Cheers,
/fuad


>
> Thanks,
> Itaru.
>
> >
> > Cheers,
> > /fuad
> >
> >
> > >         case VM_MODE_P52V48_4K:
> > >                 vm->mmu.pgtable_levels = 4;
> > >                 break;
> > >         case VM_MODE_P52V48_64K:
> > > +       case VM_MODE_P52V52_64K:
> > >                 vm->mmu.pgtable_levels = 3;
> > >                 break;
> > >         case VM_MODE_P48V48_4K:
> > > @@ -322,6 +332,7 @@ struct kvm_vm *____vm_create(struct vm_shape shape)
> > >         case VM_MODE_P48V48_16K:
> > >         case VM_MODE_P40V48_16K:
> > >         case VM_MODE_P36V48_16K:
> > > +       case VM_MODE_P52V52_16K:
> > >                 vm->mmu.pgtable_levels = 4;
> > >                 break;
> > >         case VM_MODE_P47V47_16K:
> > >
> > > --
> > > 2.43.0
> > >
> >
