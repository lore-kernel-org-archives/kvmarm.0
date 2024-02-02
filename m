Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26EEF17C6B
	for <kvmarm@lists.linux.dev>; Fri,  2 Feb 2024 06:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706857099; cv=none; b=eELdBSvCHJNLJ81TSmCqyGAhIbBKHgBTtuSFs1l8Ber7y8BZxImiw0bwsIXVhP+WKcruJ3W3cKt/qASd5BSDSs2vGzQX13FC5CsahZuDXdKvfHd1yZQXopWA/yU9JfVcPZpJQAUSvC8NaUxbojpJGQlNqQc3dOne2EY5RaVM2uY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706857099; c=relaxed/simple;
	bh=bfyX8EE4/uU+JXe129hEHOC/zLEOlb2+oTpWsMsoZPs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rdDM7ib49VXYvFKt5pdjSPhwt/RaiwZ6TZva1aclIGf1gx1b7UHVmtRGXdp6LLV1ERBNN2PhBBkV+RLquyWEc+5qfY2dBzcJqLPZt5hinVQ5hOM8YJQiAimclmpAdNbrQT9Q/q5lu1EffRVYptE1oS7Ksl2FsfAQoLV8gl567Rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZMWIqiEd; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZMWIqiEd"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-1d8ef977f1eso13960955ad.0
        for <kvmarm@lists.linux.dev>; Thu, 01 Feb 2024 22:58:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706857097; x=1707461897; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aeVnbjWEi5yI3wZCxJZ+3TFl6uPEJpXO65IAKcNUOWw=;
        b=ZMWIqiEd8zjohJqvo9D4TSMFJrqaQjmQsKKumaiKS/TwlE8stlJVWPx65aj4yuXJNI
         ZWjL1fjQz9cs8mXVOppPxjHMgmdhpfkyTjDWWz4rHa/dCw3YHXuUUxHECnEUdhLsVdJp
         4ZZZ1U+vTYBW0oOZk+ZF2FnqOyvhRukD+MLGF+w32fTgrYWmTOpSskvwAUhM0DdO6Ka7
         74qdbWsE7+DAIDeFxWMahgXQqyJMBfHwiLYsHepzqaI2Go4FhHeijgqFYu1Q2i9cIcqp
         IoOon3d6YK3OBuchmxki1PVcoSjdXTKPz0fh6y0D/a0HW9Ch29+QbSgPXHXtwOkExVAn
         159Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706857097; x=1707461897;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aeVnbjWEi5yI3wZCxJZ+3TFl6uPEJpXO65IAKcNUOWw=;
        b=eP06nEnzqD8yGwHhF4kILKgSg4pNGa3zfox0MJLqrD9EIp28aCQuhSCHBmn2ShdaSf
         0udt1aDUSkdjkTypVCPCTN7x/Rty8UjbNFeHTuY+XrIqFRnndLnPStXHIz0buR1I7pKZ
         mY8excnIXxIyg1CXe/ng7712FSuVqCkLHeg2njodY6tNAtVYCjpLthh+B9v6sk6s405q
         J2IAulDO2SSsV0IpZ9cwS135T9Tz3ajvMiXwjrXty70ui9zekCo9MTXak4l5RB5eqUSX
         UoYe+vb3cwu+/lhzWG8gcbIYxGaCoK57H+1xsJSKYe0THgiG8Z2MZQi0cCfDRXQMYwge
         47aA==
X-Gm-Message-State: AOJu0Yx5oxmCoU/+c8CMafdIqNQvq4sW/kay09kyZZK17JO69RcjaMkd
	g1qIdsvkshqpG9HRUtkMsHLklKTHi9k/+20LdulDvEfEwBMsblMb
X-Google-Smtp-Source: AGHT+IFBf6XLeyraYLqpgaXllqfIV8nP9aOkiHz9H9CBuCbU+/Yzwi3JwhbazRyvCR+MSQuAhK3haw==
X-Received: by 2002:a17:902:ce8c:b0:1d9:7412:834 with SMTP id f12-20020a170902ce8c00b001d974120834mr718546plg.8.1706857097435;
        Thu, 01 Feb 2024 22:58:17 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCVJmtn1TofVQ50OkhQ3d7+h/hvpgY3hL3pMQR9S++DrXoJ95NmPFx5wFTv7bvP1p2/l1zKasGkK1rD+WWnzk0PdekgWWBoWRk4nYWS8BRvT70PElYjZom3Rl0qdTRjjdtOjns3331AdDSmEOawg0WnT2m8XyVQDQAYwn7JPuJP81H7+qD7eL00OM7eZO4aKstDvUSDy6kLbKV5SaTYhXjNv5bPHsj3fWPSZMsvPgE7p1uaxNJfAY2jceiXMTarske+gOQQArkw+uqLvSq5bWvZg6PEEwChSgxUg9SJlP/fYrh3NV4WAq/ldvN/DezZK9hI7K3zk9mqC3a8UEDoxSunAP8OzgOJRcpdqNwykqePnm3DAQ9tZlxD5vWC+kH4QwqVMQf3gFEGrrprsp4X7Ez5x6S4cT1HtvqoNHsrstfzGR8kDguZc6NNun+ggT2fufC+TbxJjBqqNBEr8AK5yEGxHSjNEFgJ1aqV8sTR/1zRNnen1Dio6xSdaw+FCJi3AIxME1Z58TikkJmw=
Received: from wheely.local0.net ([1.146.53.155])
        by smtp.gmail.com with ESMTPSA id d18-20020a170903209200b001d948adc19fsm905734plc.46.2024.02.01.22.58.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Feb 2024 22:58:17 -0800 (PST)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	kvm@vger.kernel.org,
	Laurent Vivier <lvivier@redhat.com>,
	"Shaoqin Huang" <shahuang@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Nico Boehr <nrb@linux.ibm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Marc Hartmayer <mhartmay@linux.ibm.com>,
	linuxppc-dev@lists.ozlabs.org,
	linux-s390@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: [kvm-unit-tests PATCH v2 2/9] arch-run: Clean up temporary files properly
Date: Fri,  2 Feb 2024 16:57:33 +1000
Message-ID: <20240202065740.68643-3-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240202065740.68643-1-npiggin@gmail.com>
References: <20240202065740.68643-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Migration files weren't being removed when tests were interrupted.
This improves the situation.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 scripts/arch-run.bash | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index d0864360..f22ead6f 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -134,12 +134,14 @@ run_migration ()
 	qmp1=$(mktemp -u -t mig-helper-qmp1.XXXXXXXXXX)
 	qmp2=$(mktemp -u -t mig-helper-qmp2.XXXXXXXXXX)
 	fifo=$(mktemp -u -t mig-helper-fifo.XXXXXXXXXX)
+
+	# race here between file creation and trap
+	trap "trap - TERM ; kill 0 ; exit 2" INT TERM
+	trap "rm -f ${migout1} ${migsock} ${qmp1} ${qmp2} ${fifo}" RETURN EXIT
+
 	qmpout1=/dev/null
 	qmpout2=/dev/null
 
-	trap 'kill 0; exit 2' INT TERM
-	trap 'rm -f ${migout1} ${migsock} ${qmp1} ${qmp2} ${fifo}' RETURN EXIT
-
 	eval "$@" -chardev socket,id=mon1,path=${qmp1},server=on,wait=off \
 		-mon chardev=mon1,mode=control | tee ${migout1} &
 	live_pid=`jobs -l %+ | grep "eval" | awk '{print$2}'`
@@ -211,8 +213,8 @@ run_panic ()
 
 	qmp=$(mktemp -u -t panic-qmp.XXXXXXXXXX)
 
-	trap 'kill 0; exit 2' INT TERM
-	trap 'rm -f ${qmp}' RETURN EXIT
+	trap "trap - TERM ; kill 0 ; exit 2" INT TERM
+	trap "rm -f ${qmp}" RETURN EXIT
 
 	# start VM stopped so we don't miss any events
 	eval "$@" -chardev socket,id=mon1,path=${qmp},server=on,wait=off \
-- 
2.42.0

