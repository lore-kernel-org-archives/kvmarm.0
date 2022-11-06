Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F72EC4332F
	for <kvmarm@archiver.kernel.org>; Sun,  6 Nov 2022 21:51:02 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 161A24B8C1;
	Sun,  6 Nov 2022 16:51:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vjb7LZuisY1A; Sun,  6 Nov 2022 16:51:00 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DB7A74B87D;
	Sun,  6 Nov 2022 16:51:00 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 774954B87D
 for <kvmarm@lists.cs.columbia.edu>; Sun,  6 Nov 2022 16:50:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MQmR9c5n7l4w for <kvmarm@lists.cs.columbia.edu>;
 Sun,  6 Nov 2022 16:50:57 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D8DA84B877
 for <kvmarm@lists.cs.columbia.edu>; Sun,  6 Nov 2022 16:50:57 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1667771457;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=UrbKYDFjZCPZfr4X6LcH/yxZ4+9phPlU8IgRz4zvNZM=;
 b=ii8LYeCFgzQw6gUwmoUBM496z62cHniEfqcxjrIxFXA/oh6nUlEaWGmCQ7tde/m9LGBprM
 tJCUCYiVl1+c23IPCOLBGpnDLP+wF0+L/uqOrmqO5i+/HFljWWRari4JdnaYw1k0LZHc/9
 07wbFZdnf/+wWmP+DD/WeZR+2Tg2DeE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-186-832Cmw99PLiIlRcpO9nj5A-1; Sun, 06 Nov 2022 16:50:54 -0500
X-MC-Unique: 832Cmw99PLiIlRcpO9nj5A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7A9F2185A78F;
 Sun,  6 Nov 2022 21:50:53 +0000 (UTC)
Received: from [10.64.54.78] (vpn2-54-78.bne.redhat.com [10.64.54.78])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 045C040C6EC4;
 Sun,  6 Nov 2022 21:50:46 +0000 (UTC)
Subject: Re: [PATCH v8 0/7] KVM: arm64: Enable ring-based dirty memory tracking
To: Marc Zyngier <maz@kernel.org>
References: <20221104234049.25103-1-gshan@redhat.com>
 <87leoof4l9.wl-maz@kernel.org>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <e7196fb5-1e65-3a5b-ba88-1d98264110e3@redhat.com>
Date: Mon, 7 Nov 2022 05:50:44 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <87leoof4l9.wl-maz@kernel.org>
Content-Language: en-US
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Cc: kvm@vger.kernel.org, catalin.marinas@arm.com, andrew.jones@linux.dev,
 dmatlack@google.com, will@kernel.org, shan.gavin@gmail.com, bgardon@google.com,
 kvmarm@lists.linux.dev, pbonzini@redhat.com, zhenyzha@redhat.com,
 shuah@kernel.org, kvmarm@lists.cs.columbia.edu, ajones@ventanamicro.com
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: Gavin Shan <gshan@redhat.com>
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Marc,

On 11/7/22 12:08 AM, Marc Zyngier wrote:
> On Fri, 04 Nov 2022 23:40:42 +0000,
> Gavin Shan <gshan@redhat.com> wrote:
>>
>> This series enables the ring-based dirty memory tracking for ARM64.
>> The feature has been available and enabled on x86 for a while. It
>> is beneficial when the number of dirty pages is small in a checkpointing
>> system or live migration scenario. More details can be found from
>> fb04a1eddb1a ("KVM: X86: Implement ring-based dirty memory tracking").
>>
>> This series is applied to v6.1.rc3, plus commit c227590467cb ("KVM:
>> Check KVM_CAP_DIRTY_LOG_{RING, RING_ACQ_REL} prior to enabling them").
>> The commit is currently in Marc's 'fixes' branch, targeting v6.1.rc4/5.
> 
> This is starting to look good to me, and my only concerns are around
> the documentation and the bit of nitpicking on patch 4. If we can
> converge quickly on that, I'd like to queue this quickly and leave it
> to simmer in -next.
> 

Ok, thanks.

>> v7: https://lore.kernel.org/kvmarm/20221031003621.164306-1-gshan@redhat.com/
>> v6: https://lore.kernel.org/kvmarm/20221011061447.131531-1-gshan@redhat.com/
>> v5: https://lore.kernel.org/all/20221005004154.83502-1-gshan@redhat.com/
>> v4: https://lore.kernel.org/kvmarm/20220927005439.21130-1-gshan@redhat.com/
>> v3: https://lore.kernel.org/r/20220922003214.276736-1-gshan@redhat.com
>> v2: https://lore.kernel.org/lkml/YyiV%2Fl7O23aw5aaO@xz-m1.local/T/
>> v1: https://lore.kernel.org/lkml/20220819005601.198436-1-gshan@redhat.com
>>
>> Testing
>> =======
>> (1) kvm/selftests/dirty_log_test
>> (2) Live migration by QEMU
> 
> Could you point to a branch that has the required QEMU changes?
> 

I'm still under progress to figure out migrating the (extra) dirty pages,
which is tracked by the backup bitmap. So the branch is pre-mature.

   git@github.com:gwshan/qemu.git ("kvm/arm64_dirtyring")

Thanks,
Gavin

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
