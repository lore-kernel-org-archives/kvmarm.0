Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10F9828FFE1
	for <kvmarm@lists.linux.dev>; Mon, 30 Jun 2025 15:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751297114; cv=none; b=exDfpZi6f3F+o1UH23FkUuOL+RwTAeqRZMMoAOLq8c3ztwf3C+zAKGjRSv76NaR6hvWHh2q/J4VyfwEL5T/OBhbrGFrsFZc0jt4rO/sUl6fFF9kpz4iP2sD4te1nYsDf/3AXt9rZQJuS1lGX55PaqZhTJqIBUqMDtR9qofDk2UI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751297114; c=relaxed/simple;
	bh=GiY/rZ9Av5n7y+2/JxdS8+u5YNjs8Yxk9jMN3Ik/rqs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=K/kyJ3nKCGxeudKg3YSnzGOCbWCltTnrWGJAl0XZQ3Cb9GKoMNFN3BAm6/PF54ZGE/uZU310BRVIpSHgImZnlbQ4bQ7XPhMOzVrLGGljDBQsjh3Jcvtcsu1xfI1H/QsytUlr8OLMysBIeMokhBT8vSDKxxiLvxuGqeBeanRCZKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=zDtpctBL; arc=none smtp.client-ip=209.85.128.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="zDtpctBL"
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-714067ecea3so17227357b3.0
        for <kvmarm@lists.linux.dev>; Mon, 30 Jun 2025 08:25:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751297112; x=1751901912; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=I5h/4tT6uYWyspNT7UisC2lRP7Ask7OpjyLTLtPE4HQ=;
        b=zDtpctBLY0W0zLA344kzpUmGfVtqkubipg1Lb4dRhmKt6cF2F5s9fsf4RtHYl7JHTX
         AWjEb68cSV6l+u94kRZADRZXDrl6UkpOXlw6TXbVflbFYIy+Q1iSWjnMeZeGrGAYNHiV
         bh6iFo4eiVzl08VqkZt5yoCl+OB1VKSfTUplZhAK2ivEZNxSjQHM5y2nM0Mq4cKoEc8A
         +nsrH7+ePGzewfjAhhhf3Z91wHcodQVlPSalLkjNQT0J0/pfmaq60u5bFRydIjm+qriq
         NKNkquIR1ienVEOztY980SsaSculLaJXa/wvHvuEyjTpWmF2ZMKa9oDUgD5QpFHedLYM
         Jrqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751297112; x=1751901912;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=I5h/4tT6uYWyspNT7UisC2lRP7Ask7OpjyLTLtPE4HQ=;
        b=igR6cbS29fy6X0qaeRA0Xnzln1Z3UCyoe4sPz7jXTHb/DNbJIU5RSwAXkllOxfPE3W
         v4gepk4sntdylGffB5g6ligHsskEJCLanD9qrPZPIjEDRQ9yrZpCzJb9X61WrIO4p1vb
         1VWIsl282kbXtMANsBSAnaJe63vNRyNtGNrkMWXwvWLysxGxlS+Uw24Fcm6KEe4waiSE
         4og2+kVjDDi7eBS2JVnswvtn9pbV0++5FD9PISDfoVk/ht00EuZfW+y+wlN/Qf4X15/+
         6poZtLlEhhQqb913rSwlu9n8MCnckipxtCvIe6tsvNIWZaWS2TZ0MLSbHUUbU65ynozT
         EJXg==
X-Forwarded-Encrypted: i=1; AJvYcCVvTQh8u9oP2WslLIPelUCVaoKQq+IAtNdhhhQ1aOkehbuFkyEUyAoxKBdJsr3DIf5oORvTWCM=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyk0bvfGlgiMBtMQugx0tYa61XjUafTA0EDx/keYMBQVIkKUFZM
	LJRkk8b5S2VkWN9hI/Ywcf3mo/55l+exn3eVmStYwbk86XeIsdX0BAzhG8qnoLzb8yS2dUNK4C2
	THBLziPxxpkoHy6XUGrFb12gR2RWUgFU5xmVbedsqvQ==
X-Gm-Gg: ASbGncumrkWggPoyUlNGZif2Npc9mv1QuChazsSJpDIFIyR6LJ2DhyxQ3gIbDea53rU
	PfQj/kVkALZaEK5um8jEGRK0hkQYxDpMiEdw0ZhADELXzQxZET6t+3jzxG8psZc2lkX1Ok1oWXw
	I294jh962kZao7rKwH8FCdMff7aB0MTTr0SkVstq0ACf6N
X-Google-Smtp-Source: AGHT+IHbDKkB+v2UqZI/qbpQTn8DDgm/V9SQW5oPnLxD8oZI4VSXOLZFRxjLJnIc+/ugHtVSQMvSaqZsLIPCSyZdD+4=
X-Received: by 2002:a05:690c:dc9:b0:70e:142d:9c52 with SMTP id
 00721157ae682-7151719cf61mr215756077b3.22.1751297111869; Mon, 30 Jun 2025
 08:25:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250617153931.1330449-1-cohuck@redhat.com>
In-Reply-To: <20250617153931.1330449-1-cohuck@redhat.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Mon, 30 Jun 2025 16:25:00 +0100
X-Gm-Features: Ac12FXw50PpiOmK56GCGuI5ZjfhKrVyyA1XeCo2Esd3LtbqKHdL_R1y58yMuILw
Message-ID: <CAFEAcA-Zuqzqg_qUQh+yT4BGqEke3=OhSr0iSY1ztPtVV506sw@mail.gmail.com>
Subject: Re: [PATCH v8 00/14] arm: rework id register storage
To: Cornelia Huck <cohuck@redhat.com>
Cc: eric.auger.pro@gmail.com, eric.auger@redhat.com, qemu-devel@nongnu.org, 
	qemu-arm@nongnu.org, kvmarm@lists.linux.dev, richard.henderson@linaro.org, 
	alex.bennee@linaro.org, maz@kernel.org, oliver.upton@linux.dev, 
	sebott@redhat.com, shameerali.kolothum.thodi@huawei.com, armbru@redhat.com, 
	berrange@redhat.com, abologna@redhat.com, jdenemar@redhat.com, 
	agraf@csgraf.de, shahuang@redhat.com, mark.rutland@arm.com, philmd@linaro.org, 
	pbonzini@redhat.com
Content-Type: text/plain; charset="UTF-8"

On Tue, 17 Jun 2025 at 16:39, Cornelia Huck <cohuck@redhat.com> wrote:
>
> Mostly addressed Peter's feedback:
> - make sure every inbetween stage compiles (also fixed some bonus issues)
> - try to make the scripts more robust, add a note the generated file,
>   and make sure to grab only registers we actually want
>   - I did a half-hearted attempt to use python instead of awk, but I'm
>     out of my depth, especially with the script that will be used for
>     the register fields in the cpu models series
>
> Also available at
> https://gitlab.com/cohuck/qemu/-/commits/arm-rework-idreg-storage-v8

The script seems to be creating array entries for some registers
it should not still; I've left comments on that patch.

I've taken patches 1-11 and 14 into target-arm.next so you don't
have to keep rebasing them.

thanks
-- PMM
